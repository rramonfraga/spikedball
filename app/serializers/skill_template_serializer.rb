class SkillTemplateSerializer < ActiveModel::Serializer
  attributes  :id, 
              :name,
              :category,
              :description
end
