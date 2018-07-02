module Admin::ImportHelper

  def importable_models_collection
    [
      [t("file_users"),"User"],
      [t("file_tickets"),"Topic"],
      [t("file_replies"),"Post"],
      [t("file_docs"),"Doc"],
      [t("file_categories"),"Category"],
      [t("file_forums"), "Forum"]
    ]
  end

end
