# TODO: use lists or other abstraction method to organize these vars, so that
# we aren't polluting GlobalEnv as much.

# TODO: make this clearer, more organized.
dir_raw_relative = "data-raw/"
dir_data_relative = "data/"

#input_file = "dataforchris2.sas7bdat"
input_file = "data_grace3.sas7bdat"
local_file = paste0(dir_raw_relative, input_file)

dir_network = "J:/SAFE/EDMD/Mark - Chest Pain/dataforChris/"

# Attempt to load from local directory, e.g. if we're on the R server.
if (file.exists(local_file) ||
    file.exists(paste0(dir_data_relative, "import-data.RData"))) {
  data_dir = dir_data_relative
  raw_dir = dir_raw_relative
  
} else {
  # Otherwise load from the network drive (J:/).
  data_dir = paste0(dir_network, dir_data_relative)
  raw_dir = paste0(dir_network, dir_raw_relative)
}

# Clean up.
rm(input_file, local_file)