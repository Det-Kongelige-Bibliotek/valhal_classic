# -*- encoding : utf-8 -*-
class BasicFile < ActiveFedora::Base
  include Concerns::GenericFile
  include Hydra::AccessControls::Permissions
end
