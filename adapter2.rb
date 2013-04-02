#!/usr/bin/env ruby

class SalaryCalculation
  def get_saraly(employee)
    employee.payment_hour * employee.work_hours
  end
end

class Employee
  def payment_hour
    1
  end

  def work_hours
    8 * 5 * 4
  end
end

class Manager
  def salaly
    250
  end
end

class ManagerAdapter < Manager
  def initialize(manager)
    @manager = manager
  end

  def payment_hour
    @manager.salaly
  end

  def work_hours
    1
  end
end
