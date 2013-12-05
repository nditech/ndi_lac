# encoding: utf-8

class Organization < ActiveRecord::Base
  audited
  
  has_many :contacts
  
  TYPES = {
    "1" => "Organización No Gubernamental",
    "2" => "Centro de Pensamiento",
    "3" => "Rama Legislativa",
    "4" => "Rama Judicial",
    "5" => "Partido Político",
    "6" => "Movimiento Político",
    "7" => "Gobierno Nacional",
    "8" => "Gobierno Departamental",
    "9" => "Gobierno Municipal",
    "10" => "Medio de Comunicación",
    "11" => "Otro"
  }
  
  def self.to_select
    all.map {|organization| [organization.name.humanize, organization.id]}.push(['Crear nueva organizacion', 'crear_nuevo'])
  end
end
