class TestplanController < ApplicationController
  def new   
@builds=Build.find(:all)
testcas=Testcase.find(:all)
@testcases=Array.new()
testcas.each {|t|
@testcases.push(t.testcase_id.to_s)
}
@testcases.push("New suggestion")
@reporter=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur","Venkat", "Poornima","Bhaskar","Arvind","Raj"]

    case request.method
      when :post
      @testplan=Testplan.new(params[:testplan])
      if @testplan.save        
        flash[:notice] = "Changes saved"
        redirect_to :action=>'list'
        else
          flash[:notice] = "Failed to Save changes"
        end
      end
      
    end
    def list
      @testplans=Testplan.find(:all)
      @status=["Included", "Rejected", "Accepted but Not yet Included", "Others"]
    end
    def edit
      @testplan=Testplan.find(params[:id])
      if @testplan.update_attributes(params[:testplan])
        flash[:notice] = "Changes saved"
        redirect_to :controller=>'testplan', :action=>'list'
        else
          flash[:notice] = "Failed to save changes"
        end      
      
    end
    
end
