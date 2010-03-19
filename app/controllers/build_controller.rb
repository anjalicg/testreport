class BuildController < ApplicationController
  layout 'standard'
  def new    
    case request.method
      when :post
      @build=Build.new(params[:build])
      if @build.save        
        flash[:notice] = "Changes saved"
        redirect_to :action=>'list'
        else
          flash[:notice] = "Failed to Save changes"
        end
      end
      
    end
    def list
      @builds=Build.find(:all)
      testcases=Testcase.find(:all)
      @t=Hash.new(0)
      count=0
      testcases.each {|t|
      @builds.each {|b|
      if t.build_id.to_i == b.id.to_i
        @t[b.name]+=1
      end
      
      }
      
      }
      
    end
end
