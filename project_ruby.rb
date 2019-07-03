#!/usr/bin/env ruby
class Department
	attr_accessor :a, :b, :c, :depId, :depSize, :sections, :depName
	def initialize(depId, depName)
		@depId = depId
		@depName = depName
		@sections={"A"=>[],"B"=>[],"C"=>[]}
		@depSize = 0
	end
	def addStudentToDepartment(name)
		if depSize < 30
			@sections.each do |section_name, section_students|
				if section_students.size < 10
					section_students.push(name)
					section_students.sort!
					@depSize += 1
					tempRno = (section_students.index(name)+1)
					if tempRno <10
						puts "#{@depId + section_name}0#{tempRno}"
					else
						puts "#{@depId + section_name}#{tempRno}"
					end
					return section_name
				end
			end
		else
			puts "Error: This Department is full."
		return nil
		end
	end
	def changeSection(name, old_section_name, new_section_name)
		#complete the code
		if @sections[new_section_name].size < 10
			@sections[old_section_name].delete_at(@sections[old_section_name].index(name))
			@sections[old_section_name].sort!
			@sections[new_section_name].push(name)
			@sections[new_section_name].sort!
			puts "You have been alloted section #{new_section_name}."
			tempRno = @sections[new_section_name].index(name)+1
					if tempRno <10
						puts "#{@depId + new_section_name}0#{tempRno}"
					else
						puts "#{@depId + new_section_name}#{tempRno}"
					end
			return 1
		else
			puts "Error: Section-#{section} is full!"
			return nil
		end
	end
	def showAllStudentsInSection(section_name)
		case section_name
		when "A"
			section = @sections["A"]
		when "B"
			section = @sections["B"]
		else
			section = @sections["C"]
		end
		if section.length > 0
			section.length.times do |i|
				puts "#{@depName + "-" + section_name + "-" + section[i]}"
			end
		end
	end
end

class Main
	attr_accessor :departments, :studentsMap
	def initialize
		@departments = [Department.new("EEE01", "EEE"), Department.new("MEC01", "MECH"), Department.new("CSE01","CSE"), Department.new("CVL01","CIVIL")]
		@studentsMap = {}
	end

	def enrollInADepartment
		puts "What is your name?"
		name = nil
		loop do
			name = gets.chomp
			if @studentsMap.has_key?(name) || name == nil
				puts "Error: That name is taken. Please provide another name."
			else
				break
			end
		end
		puts "Please select your department from the given choices?
			EEE
			MECH
			CSE
			CIVIL"
		dep_index = getDepartmentIndex
		section_name = @departments[dep_index].addStudentToDepartment(name)
		studentsMap[name] = [dep_index, section_name]
		puts "Press Enter to go back to actions."
		gets
	end

	def getDepartmentIndex
		dep_index = -1
		loop do
			department = gets.chomp
			case department
			when "EEE"
				dep_index = 0
				break
			when "MECH"
				dep_index = 1
				break
			when "CSE"
				dep_index = 2
				break
			when "CIVIL"
				dep_index = 3
				break
			else
				puts "Error: Please enter the department name properly."
			end
		end
		return dep_index
	end

	def viewDetails
		puts "Please choose the details you would like to get?
			1.List all students in a department
			2.List details of a student
			3.Go back"
		option = gets.to_i
		case option
		when 1
			puts "Please select your department from the given choices?
				EEE
				MECH
				CSE
				CIVIL"
			dep_index = getDepartmentIndex
			puts "Please select your section from the given choices?
				A
				B
				C"
			section_name = readSection
			@departments[dep_index].showAllStudentsInSection(section_name)
		when 2
			puts "Please enter roll number of the student?"
			rollNo = gets.chomp
			indx = rollNo[6..7].to_i - 1
			section = rollNo[5]
			depId = rollNo[0..4]
			dep_index = getDepartmentIndexFromDepId(depId)
			if dep_index == nil || @departments[dep_index].sections[section] ==nil || @departments[dep_index].sections[section] == nil
				puts "Error: Invalid rollNo"
			else
				puts "#{@departments[dep_index].sections[section][indx]} - #{@departments[dep_index].depName} - #{section}"
			end
		else
			return
		end
	end

	def getDepartmentIndexFromDepId(depId)
		case depId
		when "EEE01"
			return 0
		when "MEC01"
			return 1
		when "CSE01"
			return 2
		when "CVL01"
			return 3
		end
		return nil
	end

	def readSection
		section_name = nil
		puts "Please select your section from the given choices?
		A
		B
		C"
		loop do
			section_name = gets.chomp
			if ["A","B","C"].index(section_name)!=nil && section_name != nil
				break
			else
				puts "Error: Please enter a valid section name:A/B/C."
			end
		end
		return section_name
	end
	def changeSection
		puts "What is your name?"
		name = gets.chomp
		loop do
			if @studentsMap.has_key?(name)
				break
			else
				puts "Error: Your name is not found! Please verify and enter."
				name = gets.chomp
			end
		end
		old_section_name = @studentsMap[name][1]
		new_section_name = readSection
		if old_section_name != new_section_name
			if @departments[@studentsMap[name][0]].changeSection(name,old_section_name, new_section_name) != nil
				@studentsMap[name][1] = new_section_name
				puts "cehck: new_section_name #{new_section_name}, @studentsMap[name][1] #{@studentsMap[name][1]}"
			end
		else
			puts "You are in section #{new_section_name} only!"
		end
		puts "Press Enter to go to actions."
		gets
	end
	def changeDepartment
		puts "What is your name?"
		name = gets.chomp
		loop do
			if @studentsMap.has_key?(name)
				break
			else
				puts "Error: Your name is not found! Please verify and enter."
				name = gets.chomp
			end
		end
		old_dept = @studentsMap[name][0]
		old_section = @studentsMap[name][1]
		@departments[old_dept].sections[old_section].delete(name)
		@departments[old_dept].sections[old_section].sort!
		@departments[old_dept].depSize = @departments[old_dept].depSize - 1
		puts "Please select your department from the given choices?
			EEE
			MECH
			CSE
			CIVIL"
		dep_index = getDepartmentIndex
		section_name = @departments[dep_index].addStudentToDepartment(name)
		@studentsMap[name] = [dep_index, section_name]
	end
end

main = Main.new
loop do
	puts "Please choose the action you would like to perform?
	1.Enroll into a department
	2.Change your department
	3.Change your section
	4.View details"
	puts "#{main.studentsMap}"
	option = gets.to_i
	case option
	when 1
		main.enrollInADepartment
	when 2
		main.changeDepartment
	when 3
		main.changeSection
	when 4
		main.viewDetails
	else
		puts "Error: Please enter a number from 1 to 4."
	end
end
