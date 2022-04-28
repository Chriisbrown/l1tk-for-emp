import conifer
import sys
import joblib


bdt_model = joblib.load("../models/"+sys.argv[1]) 
print("Model File Loaded")


cfg = conifer.backends.vivadohls.auto_config()
cfg['Precision'] = 'ap_fixed<18,15>'   #This parameter controls the internal quantisation of the BDT
cfg['OutputDir'] = "dir/"
cfg["XilinxPart"] = "xcvu7p-flvb2104-2-e"
cfg["ClockPeriod"] = "2.7"

try:
   hdl_model = conifer.model(bdt_model.get_booster(), conifer.converters.xgboost, conifer.backends.vhdl, cfg) #Create Conifer model
except:
    try:
         hdl_model = conifer.model(bdt_model, conifer.converters.sklearn, conifer.backends.vhdl, cfg) 
    except:
        print("Invalid BDT savefile, either xgboost or sklearn is currently supported") 
  
hdl_model.compile()
print("Model Compiled")

