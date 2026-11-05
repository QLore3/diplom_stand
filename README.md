# Дипломный стенд DevOps

## Этап 1 — облачная инфраструктура

В Yandex Cloud созданы сервисные аккаунты с ограниченными правами, закрытый S3 bucket для Terraform state с версионированием и блокировкой, отдельная VPC, три подсети и три ВМ.

- Control plane — непрерываемая ВМ; два worker — прерываемые.
- Каждая ВМ: 2 vCPU, 2 ГБ RAM, CPU 20%, HDD 10 ГБ, Ubuntu 24.04.
- SSH и Kubernetes API ограничены административным CIDR.
- Проверены SSH, внутренняя связь, доступ к GHCR и отсутствие изменений при повторном Terraform plan.

`terraform/bootstrap` — аккаунты и backend, `terraform/main` — сеть и ВМ. Параметры описаны в `variables.tf`; примеры настроек — в `*.example.tfvars`. Рабочие `terraform.tfvars`, ключи и state в Git не хранятся. При инициализации main настройки S3 передаются через `terraform init -backend-config=...`, credentials — через окружение.

ВМ размещены в зонах `a` и `d`: создание ВМ в `b` недоступно, подсеть `b` сохранена без ВМ. Полный цикл destroy/apply проверим на заключительном этапе.

Приложение: [diplom_app](https://github.com/QLore3/diplom_app), registry — GHCR. Kubernetes, приложение и мониторинг — следующие этапы.
