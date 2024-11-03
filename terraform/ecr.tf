resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "my-ecr-repo"
  image_tag_mutability = "MUTABLE"  # or "IMMUTABLE" based on your requirement
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "my_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description   = "Keep only 10 images"
        selection     = {
          countType        = "imageCountMoreThan"
          countNumber      = 10
          tagStatus        = "tagged"
          tagPrefixList   = ["prod"]
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

output "EcrUrl" {
  value = aws_ecr_repository.my_ecr_repo.repository_url
}