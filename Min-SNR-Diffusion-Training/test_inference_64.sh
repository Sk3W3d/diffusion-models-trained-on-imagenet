
# pip install -r requirements.txt
# pip install -e .

# if [ ! -d edm ]; then
#     git clone https://github.com/NVlabs/edm.git
# fi

export NCCL_DEBUG=WARN

GPUS=1
IMG_SIZE=64
BATCH_SIZE=32
NUM_SAMPLES=50000
MODEL_NAME="vit_large_patch4_64"
DEPTH=21
GUIDANCE_SCALES="1.5"
STEPS="20"
PRED_X0=False


CKPT="exp/guided_diffusion/ema_0.9999_large.pt"

# if [ -e $CKPT ]; then
#     echo "$CKPT exists."
# else
#     echo "$$CKPT does not exist.";
#     sudo mkdir -p exp/guided_diffusion/;
#     sudo wget https://github.com/TiankaiHang/Min-SNR-Diffusion-Training/releases/download/v0.0.0/ema_0.9999_large.pt -O $CKPT;
# fi

MODEL_FLAGS="--class_cond True --image_size $IMG_SIZE --model_name ${MODEL_NAME} --depth $DEPTH --in_chans 3 --predict_xstart $PRED_X0 "
DIFFUSION_FLAGS="--diffusion_steps 1000 --noise_schedule cosine --rescale_learned_sigmas False --rescale_timesteps False"

# ----------- scale loop ------------- #
for GUIDANCE_SCALE in $GUIDANCE_SCALES
do

for STEP in $STEPS
do

SAMPLE_FLAGS="--batch_size $BATCH_SIZE --num_samples ${NUM_SAMPLES} --steps $STEP --guidance_scale $GUIDANCE_SCALE"

OPENAI_LOGDIR="exp/guided_diffusion/large_samples${NUM_SAMPLES}_step${STEP}_scale${GUIDANCE_SCALE}"
# sudo mkdir -p $OPENAI_LOGDIR && sudo chmod 777 $OPENAI_LOGDIR
mkdir -p $OPENAI_LOGDIR && chmod 777 $OPENAI_LOGDIR
OPENAI_LOGDIR=$OPENAI_LOGDIR torchrun --nproc_per_node=$GPUS --master_port=23456 scripts_vit/sampler_edm.py --model_path $CKPT $MODEL_FLAGS $DIFFUSION_FLAGS $SAMPLE_FLAGS

# cd edm
# torchrun --standalone --nproc_per_node=$GPUS fid.py calc --images=../$OPENAI_LOGDIR --ref=https://openaipublic.blob.core.windows.net/diffusion/jul-2021/ref_batches/imagenet/64/VIRTUAL_imagenet64_labeled.npz --num $NUM_SAMPLES 
# cd ..

done
done
# ----------- scale loop ------------- #

echo "----> DONE <----"


# -----------------------------------
#          expected output
# -----------------------------------
# Calculating FID...
# 2.275