# -*- encoding : utf-8 -*-
module InstanceSpecHelper
  def association_with_ie(ins, ie)
    ins.ie = ie
    ins.ie.should == ie
  end

  def save_ie_association(ins, ie)
    ins.ie = ie
    ins.save.should be_true
  end

  def ie_from_saved_ins(ins, ie)
    ins.ie = ie
    ins.save
    pid = ins.pid
    def_ins = ins.class.find(pid)
    def_ins.ie.should == ie
  end

  def values_from_ie_via_ins(ins, ie, method)
    ins.ie = ie
    ins.save
    pid = ins.pid
    def_ins = ins.class.find(pid)
    def_ins.ie.send(method).should == ie.send(method)
  end
end