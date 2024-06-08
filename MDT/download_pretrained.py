from huggingface_hub import snapshot_download
import os

models_path = snapshot_download("shgao/MDT-XL2")
ckpt_model_path = os.path.join(models_path, "mdt_xl2_v2_ckpt.pt")

