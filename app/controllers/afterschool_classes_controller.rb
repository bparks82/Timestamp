class AfterschoolClassesController < ApplicationController
  def index
    @afterschool_classes = AfterschoolClass.find(:all)
    @session = Session.new
  end

  def new
    @afterschool_class = AfterschoolClass.new
    @afterschool_class.teachers.build
    @afterschool_class.students.build
  end

  def create
    @afterschool_class = AfterschoolClass.new(params[:afterschool_class])
    if @afterschool_class.save
      students_from_csv
      flash[:success] = "Class successfully created!"
      redirect_to @afterschool_class
    else
      render :new
    end
  end

  def show
    @afterschool_class = AfterschoolClass.find(params[:id])
  end

  def students_from_csv
    unparsed_file = File.open(params[:file][:post].tempfile.to_path.to_s).read
    parsed_csv = CSV.parse(unparsed_file)
    puts parsed_csv.inspect
    parsed_csv.each_with_index do |row, index|
      next if index == 0
      @afterschool_class.students.create(first_name: row[0], last_name: row[1])
    end
  end
end

