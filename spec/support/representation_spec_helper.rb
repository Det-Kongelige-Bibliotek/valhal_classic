module RepresentationSpecHelper
  def association_with_ie(rep, ie)
    rep.ie = ie
    rep.ie.should == ie
  end

  def save_ie_association(rep, ie)
    rep.ie = ie
    rep.save.should be_true
  end

  def ie_from_saved_rep(rep, ie)
    rep.ie = ie
    rep.save
    pid = rep.pid
    def_rep = rep.class.find(pid)
    def_rep.ie.should == ie
  end

  def values_from_ie_via_rep(rep, ie, method)
    rep.ie = ie
    rep.save
    pid = rep.pid
    def_rep = rep.class.find(pid)
    def_rep.ie.send(method).should == ie.send(method)
  end
end