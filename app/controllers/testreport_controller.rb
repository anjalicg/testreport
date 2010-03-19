require 'spreadsheet'
require 'mysql'
class TestreportController < ApplicationController
  def new    
    @testcases=Testcase.find(:all)
    @executer=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur","Venkat", "Poornima","Bhaskar","Arvind","Raj"]
    @releases=Release.find(:all)
    @result=["PASS","FAIL","NA","In Progress","BLOCK","Can Not Run"]
    @build=Build.find(:all)
    case request.method
      when :post
      @testr=Testreport.new(params[:testreport])
      if @testr.save        
        #~ print "\n test case saved successfully\n"
        flash[:notice] = "Changes saved"
        redirect_to :controller=>'release', :action=>'list'
        else
          flash[:notice] = "Changes were not saved. Please try again"
        end
      end
      
    end
    def list
      @testrs=Testreport.find(:all)
    end
    
    def edit
      @testreport=Testreport.find(params[:id])
      @testcases=Testcase.find(:all)
      @executer=["Anjali", "Chethana", "Bhavana", "Senthil", "Balakrishna", "Fazalur", "Venkat", "Poornima","Bhaskar","Arvind","Raj"]
      @result=["PASS","FAIL","NA","In Progress","BLOCK","Can Not Run"] 
    end
    def update
      @testreport=Testreport.find(params[:id])
      #puts "Test report:- #{@testreport.attributes}"
        if @testreport.update_attributes(params[:testreport])
          flash[:notice] = "Changes Saved for #{@testreport.id} #{@testreport.testcase.testcase_id} #{@testreport.executed_by} "
          if params[:type] == 'show'
            redirect_to :controller=>'release', :action=>'show', :id=>params[:release_id]
            elsif params[:type]=='sort'
              redirect_to :controller=>'release', :action=>'sort', :id=>params[:release_id]
              elsif params[:type]=='sort_by_profile'
                redirect_to :controller=>'release', :action=>'sort_by_profile', :id=>params[:release_id]
                elsif params[:type]=='show_profile'
                  #render :text=>params[:profile]
                  redirect_to :controller=>'release', :action=>'show_profile', :release_id=>params[:release_id], :profile=>params[:profile]
              end         
          else
            #~ print "Fail saved"
            flash[:error] = "Failed to save changes. Please rectify the errors and try again "
          end
      end
    
    def delete
      Testreport.find(params[:id]).destroy
      redirect_to :action=>'list'      
    end
    def show
      @testreport=Testreport.find(params[:id])
    end
    def skele_rep
      @release=Release.find(:all)
      @builds=Build.find(:all)
      @releases=Release.find(:all)
    end
    def generate_skele
      @testcases=Array.new
      @builds=Build.find(:all)
      @status=Array.new()      
      release=params[:testreport][:release_id]
      @builds.each {|b|
      @status=@status.push(b.name+b.id.to_s+"params->"+params[b.id.to_s][b.name])
      if params[b.id.to_s][b.name]==1.to_s        
        @testcases=@testcases.push(Testcase.find(:all,:conditions=>{:build_id=>b.id})).flatten         
      end
      }
      @testcases.each {|t1|
      @t=t1.testcase_id
      Testreport.create(:testcase_id=>t1.id)  do |r|
      r.release_id = release
      r.build_id=t1.build_id
       end
      }
      @selected_testcase=Testreport.find(:all, :conditions =>{:release_id =>release})
      redirect_to :controller=>'release',:action=>'show',:id=>params[:testreport][:release_id]
    end
    def uploadfile
      @builds=Build.find(:all)
      @release=Release.find(:all)
      end
      
def uploadFile2server
    @message=Array.new(0)
    book =Spreadsheet.open (params[:upload][:datarfile])
    row1=params[:upload][:row].to_i 
    row1-=1
    sheet1=book.worksheet 0
    ms =Mysql.new('localhost','root','gain','testreport_production')
    list=Build.find(:all)
    testcases=Testcase.find(:all)
    release=params[:upload][:release_id].to_i
    #~ puts "Release id class #{release.class}"
    
   for i in row1..sheet1.row_count
        #puts sheet1[i,1]
        if sheet1[i,1] and sheet1[i,2] and sheet1[i,3] and get_build(sheet1[i,4],list).to_s
          # id  | executed_by | result | observation | deviations | build_id | testcase_id | release_id | updated_at |
          if sheet1[i,6]
          deviations = sheet1[i,6].gsub(/ /,"")
          else 
            deviations=sheet1[i,6]
          end
          
           if sheet1[i,7]
          result = sheet1[i,7].gsub(/ /,"")
          else 
            result =  sheet1[i,7]
            end
            
            if sheet1[i,8]
          observation = sheet1[i,8].gsub(/ /,"")
          else 
            observation= sheet1[i,8]
            end
            
            if sheet1[i,5]
          executed_by = sheet1[i,5].gsub(/ /,"")
          else 
            executed_by =sheet1[i,5]
            end
            
          
          @message.push(sheet1[i,1].gsub(/ /,""))
          ms.query("insert into testreports (testcase_id, build_id,executed_by,deviations, result, observation,release_id) values (#{get_testcase(sheet1[i,1].gsub(/ /,""),testcases,get_build(sheet1[i,4],list))},#{get_build(sheet1[i,4],list)},\"#{executed_by}\", \"#{deviations}\",\"#{result}\",\"#{observation}\",#{release})")
          
          #Test Case ID,	Testcase Person,	Description,	GEPS 1.x,	Test Engineer,	Deviations,	Result,	Reasons/ Observations

     end
   end

flash[:notice] ="File succesfully uploaded to the database. #{sheet1.row_count-row1} records created "
  end
def multisaveput
=begin
Params: commit<--->Multi Save<--->String
Params: multi<--->resultPASSobservation[BugId]:Bug Summaryexecuted_byAnjalideviations<--->HashWithIndifferentAccess
Params: authenticity_token<--->lcKwiNgepaY8lwZnPZ17ta+Ij/QyBKzw7UIuvuueVNQ=<--->String
Params: action<--->multisaveput<--->String
Params: controller<--->testreport<--->String
Params: release_id<--->4<--->String
TO SAVE PARAMETERS
PASS
=end

  #~ puts "\n\n\nPARAMS Value\n\n\n"
  tosave=params["multi"]
  #~ puts "TO SAVE PARAMETERS"
  #resultPASSobservation[BugId]:Bug Summaryexecuted_byAnjalideviations<--->HashWithIndifferentAccess
  #~ puts tosave["result"]
  params.each {|p,v|
  #~ puts "Params: #{p}<--->#{v}<--->#{v.class}"
  unless p.include?("commit") or p.include?("authenticity_token") or p.include?("action") or p.include?("controller") or p.include?("release_id") or p.include?("multi")
  #~ puts "It is a ID #{p} Going to update"
  res= Testreport.update(p.to_i,:result=>tosave["result"],:observation=>tosave["observation"],:deviations=>tosave["deviations"],:executed_by=>tosave["executed_by"]) 
  #~ puts "Update status::: #{res}"
end

  
  }
  
flash[:notice] = "Updated Select test cases with #{tosave["result"]}, #{tosave["deviations"]}, #{tosave["observation"]}, #{tosave["executed_by"]}"
 redirect_to :controller=>'release' , :action=>'multisaveget',:id=>params["release_id"]
end

def filedownload
     @files=Hash.new(0)
     @timearray=Array.new(0)
     Dir.new('./public/AllReports').each {|f|
     #~ puts "File name is #{f}"
     unless f=="." or f==".."
     #~ puts "Inside unless file name is #{f}"
     x=File.join('./public/AllReports',f)
     #~ puts "Stat of file #{x}"
     @files[File.stat(x).ctime.to_i]=f
     @timearray.push(File.stat(x).ctime.to_i)
   end
   @timearray.sort!.reverse!
   #puts @timearray
   
   }
   
   case params[:method]
       when 'post'
       send_file "./public/AllReports/#{params[:name]}", :type=>"application/text"
       end
     
   end


























protected
  def get_build (name,build)
  #puts "\nName :#{name}:"
  if name
  name.gsub!(/ /,"")
  name.gsub!(/\n /,"")
  name.gsub!(/ \r\n/,"")
  end
 build.each do |b|
   if b.name==name
     return b.id
   end
 end
  
end
def get_testcase (tid, testlist,build)    
   #~ puts "\ntestcase id and build :#{tid}:#{build}"
  if tid
  tid.gsub!(/ /,"")
  tid.gsub!(/\n /,"")
  tid.gsub!(/ \r\n/,"")
end
testlist.each do |t|
  if t.testcase_id==tid and t.build_id.to_i==build.to_i
    #~ puts "\n\nTestcase ID:- #{t.id}\n\n"
    return t.id
  end
  
end

end


 
end
