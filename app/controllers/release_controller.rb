class ReleaseController < ApplicationController
  def export
    @release=Release.find(params[:id])
      @executer=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur","Venkat", "Poornima","Bhaskar","Arvind","Raj"]
      @result=["PASS","FAIL","NA","In Progress","BLOCK","Can Not Run"]
      @selected_testcase=Testreport.find(:all ,:conditions=>{:release_id=>params[:id]}, :include=>'testcase', :order=>'testcases.id')
    headers['Content-Type'] = "application/vnd.ms-excel"
    render :layout=> false
  end
  
  def new    
    case request.method
      when :post
      @release=Release.new(params[:release])
      if @release.save        
        flash[:notice] = "Changes saved"
        redirect_to :action=>'list'
        else
          flash[:notice] = "Failed to save changes"
        end
      end
      
    end
    def list
      @releases=Release.find(:all)
      @profile=["1","2","3","4","5","6","7","8","255"]
    end
    def show
      @release=Release.find(params[:id])
      @executer=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur","Venkat", "Poornima","Bhaskar","Arvind","Raj"]
      @result=["PASS","FAIL","NA","In Progress","BLOCK","Can Not Run"]
      @selected_testcase=Testreport.find(:all ,:conditions=>{:release_id=>params[:id]}, :include=>'testcase', :order=>'testcases.id')
    end
    def listexcel
      @testrs=Testreport.find(:all, :conditions=>{:release_id=>params[:id]})
      headers['Content-Type'] = "application/vnd.ms-excel"
      render :layout=> false
    end
    def delete
      Testreport.find(params[:id]).destroy
      redirect_to :action=>'show',:id=>params[:release_id]
    end
    def sort
      @release=Release.find(params[:id])
      @executer=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur","Venkat", "Poornima","Bhaskar","Arvind","Raj"]
      @result=["PASS","FAIL","NA","In Progress","BLOCK","Can Not Run"]
      @selected_testcase=Testreport.find(:all,  :conditions=>{:release_id=>params[:id]}, :order=>'result DESC')
    end
    def sort_by_profile
      @release=Release.find(params[:id])
      @executer=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur","Venkat", "Poornima","Bhaskar","Arvind","Raj"]
      @result=["PASS","FAIL","NA","In Progress","BLOCK","Can Not Run"]
      @selected_testcase=Testreport.find(:all, :conditions=>{:release_id=>params[:id]}, :include=>'testcase', :order=>'testcases.profile DESC')
    end
    def status
      @release=Release.find(params[:release_id])
      @status=Hash.new()
      all=Testreport.find(:all, :conditions=>{:release_id=>params[:release_id]})
      @status["pass"]=0
      @status["fail"]=0
      @status["inprogress"]=0
      @status["na"]=0
      @status["block"]=0
      @status["total"]=0
      @status["pending"]=0
      @status["cantrun"]=0
      @countx=Hash.new(0)
      @pcountx=Hash.new(0)
      all.each do |a|
        if a.result=="PASS"
          @status["pass"]+=1
          #print a.testcase.profile
        elsif a.result=="FAIL"
          @status["fail"]+=1
          elsif a.result=="In Progress"
          @status["inprogress"]+=1
          elsif a.result=="NA"
          @status["na"]+=1
          elsif a.result=="BLOCK"
          @status["block"]+=1
          elsif a.result=="Can Not Run"
          @status["cantrun"]+=1
        end        
        #~ puts "Going to increment the count"
          if a.testcase
            @countx[a.testcase.profile]+=1
            unless a.result
            @pcountx[a.testcase.profile]+=1
          end
          
        end
        
      
      end
      @status["total"]=all.length
      @status["pending"]=@status["total"]-(@status["pass"]+@status["fail"]+@status["na"]+@status["inprogress"]+@status["block"]+@status["cantrun"])
      
      @buglist=Testreport.find(:all,:conditions=>{:release_id=>params[:release_id], :result=>'FAIL'})
   
 end
 def select_profile
   @release=Release.find(:all)
   @profile=["1","2","3","4","5","6","7","8","255"]
 end
 
    def show_profile_new
      flash[:notice]="TestReport for Release:- #{params['input']['release_serial']} and Profile:- #{params['input']['profile']  }"
      @release=Release.find(:first, :conditions=>{:serial=>params['input']['release_serial']})
      @executer=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur","Venkat", "Poornima","Bhaskar","Arvind","Raj"]
      @result=["PASS","FAIL","NA","In Progress","BLOCK","Can Not Run"]
      #@selected_testcase=Testreport.find(:all, :include=>'testcase',:conditions=>{:release_id=>@release.id, 'testcases.profile'=>params['input']['profile']})       
      redirect_to :controller=>'release', :action=>'show_profile', :release_id=>@release.id,:profile=>params['input']['profile']
      
    end
    def show_profile
      
      @release=Release.find(params[:release_id])
      flash[:notice]="TestReport for Release #{@release.serial} and profile #{params[:profile]}"
      @executer=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur","Venkat", "Poornima","Bhaskar","Arvind","Raj"]
      @result=["PASS","FAIL","NA","In Progress","BLOCK","Can Not Run"]
      all_testcase=Testreport.find(:all, :order=>"id", :conditions=>{:release_id=>params[:release_id]})
      @selected_testcase=Array.new(0)
      #, :include=>'testcase',:conditions=>{'testcases.profile'=>params[:profile]})      
      all_testcase.each do |a|
        if a.testcase.profile.to_i==params[:profile].to_i
          #~ puts "Profile Matches #{a.testcase.profile}::::#{params[:profile]}"
          @selected_testcase.push(a)
          else
            #~ puts "Profile doesnt Matches #{a.testcase.profile}::::#{params[:profile]}"
        end # if end 
        
      end # do end
      
      
    end # def end
    
    def multisaveget
      @release=Release.find(params[:id])
      @executer=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur","Venkat", "Poornima","Bhaskar","Arvind","Raj"]
      @result=["PASS","FAIL","NA","In Progress","BLOCK","Can Not Run"]
      @selected_testcase=Testreport.find(:all, :order=>"id", :conditions=>{:release_id=>params[:id]})
    end
    
    def allresults
      dist_test=Testcase.find(:all, :select=>"DISTINCT(testcase_id), id")
      full_test=Testcase.find(:all)
      full_rep=Testreport.find(:all,:group=>"testcase_id")
      @res_set=Hash.new("0")
      @releases=Release.find(:all)
      x=File.new("makehash.txt","w")
      full_test.each {|ft|
      for i in 0..full_rep.length-1
        if full_rep[i].testcase_id.to_i == ft.id.to_i
          x<< full_rep[i].testcase_id.to_s<<":"<< ft.id.to_s
          #~ print "ID match found #{full_rep[i].testcase_id}: #{ft.id}"
          #~ res_set[full_rep[i].testcase_id.to_s] += "+#{ft.id}"
          @res_set[ft.testcase_id.to_s.gsub(/\*/,"")] += "+ #{full_rep[i].id}<->#{full_rep[i].release_id}<->#{full_rep[i].result}"
          x<< ft.testcase_id.to_s.gsub(/\*/,"") <<":"<< "+ #{full_rep[i].id}<->#{full_rep[i].release_id}<->#{full_rep[i].result}\n"
          #~ res_set[ft.testcase_id.to_s] += "+#{full_rep[i].id}"
          break
      end
          
      end
      
        }
        x.close
        f=File.new("allresult.txt","w")
        @res_set.each {|k,v|
        f<< "\n#{k}<-->#{v}:"}
        puts "hahaha..............."
        puts @res_set.length
        f.close
        @releases.each {|res|
        puts res.id}
      end
      
    
    
end

