docker build --tag ovms-bash --file  Examples/ovms/ovms-gsc.dockerfile .
./gsc build --insecure-args ovms-bash  Examples/ovms/ovms.manifest
./gsc sign-image ovms-bash enclave-key.pem
./gsc info-image gsc-ovms-bash | tee gsc_ovms_image_info
docker run gsc-ovms-bash -u $(id -u):$(id -g) -p 9000:9000 -v /mnt/tmpfs/model_encrypted:/mnt/tmpfs/model_encrypted
curl https://raw.githubusercontent.com/openvinotoolkit/model_server/releases/2023/0/demos/common/python/client_utils.py -o client_utils.py
curl https://raw.githubusercontent.com/openvinotoolkit/model_server/releases/2023/0/demos/face_detection/python/face_detection.py -o face_detection.py
curl --create-dirs https://raw.githubusercontent.com/openvinotoolkit/model_server/releases/2023/0/demos/common/static/images/people/people1.jpeg -o images/people1.jpeg
python3 -m venv env
source env/bin/activate
pip install --upgrade pip
pip install -r  Examples/ovms/client_requirements.txt
pip install "numpy<2.0"
pip3 install opencv-python
python3  Examples/ovms/face_detection.py --batch_size 1 --width 600 --height 400 --input_images_dir  Examples/ovms/images --output_dir  Examples/ovms/results --grpc_port 9000
