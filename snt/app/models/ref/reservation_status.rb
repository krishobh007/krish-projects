class Ref::ReservationStatus < Ref::TranslatableReferenceValue
  translates :description
  default_scope with_translations(I18n.locale).order(:description)
end
