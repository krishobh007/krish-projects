module SeedDepartments
  def create_departments
    hotel_id = Hotel.find_by_code('DOZERQA').id

    Department.create(name: 'Front Desk', hotel_id: hotel_id)
    Department.create(name: 'IT', hotel_id: hotel_id)
  end
end
