module ContactHelper
  def enquiry_types
    [
      { id: 'feedback', name: t('form.feedback') },
      { id: 'question', name: t('form.question') }
    ]
  end
end