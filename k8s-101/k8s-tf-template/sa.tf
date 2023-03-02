resource "yandex_iam_service_account" "kssa" {
  name        = "ksmanager"
  description = "service account to manage K8s"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.kssa.id}"
}

# data "yandex_iam_policy" "editor" {
#   binding {
#     role = "editor"

#     members = [
#       "serviceAccount:${yandex_iam_service_account.kssa.id}",
#     ]
#   }
# }

# resource "yandex_resourcemanager_folder_iam_policy" "folder_admin_policy" {
#   folder_id   = var.folder_id
#   policy_data = data.yandex_iam_policy.editor.policy_data
# }
