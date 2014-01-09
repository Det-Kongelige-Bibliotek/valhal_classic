# -*- encoding : utf-8 -*-
Hydra::FileCharacterization.configure do |config|
  config.tool_path(:fits, ENV["FITS_HOME"]) #requires env var setting: export FITS_HOME=/path/to/fits.sh
end
