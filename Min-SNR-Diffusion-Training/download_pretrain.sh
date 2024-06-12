if [ ! -d edm ]; then
    git clone https://github.com/NVlabs/edm.git
fi

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

if [ -e $CKPT ]; then
    echo "$CKPT exists."
else
    echo "$$CKPT does not exist.";
    mkdir -p exp/guided_diffusion/;
    wget https://github.com/TiankaiHang/Min-SNR-Diffusion-Training/releases/download/v0.0.0/ema_0.9999_large.pt -O $CKPT;
fi


CKPT="exp/guided_diffusion/ema_0.9999_xl.pt"

if [ -e $CKPT ]; then
    echo "$CKPT exists."
else
    echo "$$CKPT does not exist.";
    mkdir -p exp/guided_diffusion/;
    wget https://github.com/TiankaiHang/Min-SNR-Diffusion-Training/releases/download/v0.0.0/ema_0.9999_xl.pt -O $CKPT;
fi