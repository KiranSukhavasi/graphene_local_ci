curl --create-dirs https://storage.openvinotoolkit.org/repositories/open_model_zoo/2023.0/models_bin/1/face-detection-retail-0004/FP32/face-detection-retail-0004.xml https://storage.openvinotoolkit.org/repositories/open_model_zoo/2023.0/models_bin/1/face-detection-retail-0004/FP32/face-detection-retail-0004.bin -o Examples/ovms/models/1/face-detection-retail-0004.xml -o Examples/ovms/models/1/face-detection-retail-0004.bin
curl https://raw.githubusercontent.com/openvinotoolkit/model_server/releases/2023/0/demos/common/python/client_utils.py -o Examples/ovms/client_utils.py
curl https://raw.githubusercontent.com/openvinotoolkit/model_server/releases/2023/0/demos/face_detection/python/face_detection.py -o Examples/ovms/face_detection.py
curl --create-dirs https://raw.githubusercontent.com/openvinotoolkit/model_server/releases/2023/0/demos/common/static/images/people/people1.jpeg -o Examples/ovms/images/people1.jpeg
python3 -m venv env
source env/bin/activate
//sudo apt install -y python3-venv
pip install --upgrade pip
pip install -r Examples/ovms/client_requirements.txt
export no_proxy=intel.com,.intel.com,localhost,127.0.0.1
//pip3 install opencv-python
python3 Examples/ovms/face_detection.py --batch_size 1 --width 600 --height 400 --input_images_dir  Examples/ovms/images --output_dir  Examples/ovms/results --grpc_port 9000
deactivate
file_to_check="Examples/ovms/results/1_0.jpg"
output_file="Examples/ovms/result.txt"
if [ -f "$file_to_check" ]; then
    echo "SUCCESS : File exists." > "$output_file"
else
    echo "ERROR : File does not exist." > "$output_file"
fi



