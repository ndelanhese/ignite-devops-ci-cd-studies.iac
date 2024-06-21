resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "1b511abead59c6ce207077c0bf0e0043b1382612"
  ]

  tags = {
    IAC = "True"
  }
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRoleWithWebIdentity",
        Principal = {
          Federated = "arn:aws:iam::992382740209:oidc-provider/token.actions.githubusercontent.com"
        },
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ],
            "token.actions.githubusercontent.com:sub" : [
              "repo:ndelanhese/ignite-devops-ci-cd-studies.api:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })

  inline_policy {
    name = "ecr_app_permission"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "Statement1"
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:GetAuthorizationToken",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Sid      = "Statement2"
          Action   = "apprunner:*"
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Sid = "Statement3"
          Action = [
            "iam:PassRole",
            "iam:CreateServiceLinkedRole"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }

  tags = {
    IAC = "True"
  }
}

resource "aws_iam_role" "tf_role" {
  name = "tf_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRoleWithWebIdentity",
        Principal = {
          Federated = "arn:aws:iam::992382740209:oidc-provider/token.actions.githubusercontent.com"
        },
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ],
            "token.actions.githubusercontent.com:sub" : [
              "repo:ndelanhese/ignite-devops-ci-cd-studies.iac:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })

  tags = {
    IAC = "True"
  }
}

resource "aws_iam_role" "app_runner_role" {
  name = "app_runner_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Service" = "build.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ]
  tags = {
    IAC = "True"
  }
}
