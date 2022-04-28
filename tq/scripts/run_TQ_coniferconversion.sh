if [ -d "conifer" ]
then
    echo "Conifer already present"
else 
    git clone https://github.com/thesps/conifer.git
    cd conifer
    pip install .
    cd ..
fi

python -c "import joblib"
RESULT=$?
if [ $RESULT -eq 1 ]; then 
  echo "Install python package Joblib to run"
  exit 1
fi

python -c "import numpy"
RESULT=$?
if [ $RESULT -eq 1 ]; then
  echo "Install python package Numpy to run"
  exit 1
fi

python -c "import xgboost"
RESULT=$?
if [ $RESULT -eq 1 ]; then
  echo "Install python package Xgboost to run"
  exit 1
fi


if [ -d "dir" ]
then
  rm -r dir
fi

TrackQuality_url="https://cernbox.cern.ch/index.php/s/7Zo8KfaPZ7ySIt8/download"

if [ -f "models/NewKFKF.pkl" ]
then
  echo "Model Present"
else
  echo "No Model Present" 
  wget -O TQ.tar.gz --quiet ${TrackQuality_url}
  tar -xzf TQ.tar.gz
  rm -f TQ.tar.gz
  mv TQ/* models
fi

python conifer_converter.py NewKFKF.pkl

mv dir/firmware/Constants.vhd firmware/hdl
mv dir/firmware/Arrays0.vhd firmware/hdl

rm -r dir

