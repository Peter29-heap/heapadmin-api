# HeapAdmin — Backend API (Laravel 12)

[![Live Demo](https://img.shields.io/badge/Live-Demo-blue?style=flat-square)](https://heapadmin-login.vercel.app)
[![Buy on Gumroad](https://img.shields.io/badge/Buy%20on-Gumroad-pink?style=flat-square)](https://heapster2.gumroad.com/l/yoxqoc)

> REST API backend for HeapAdmin — built with Laravel 12, Sanctum authentication, and RESTful architecture.

**[→ Get the full source code (Frontend + Backend) on Gumroad](https://heapster2.gumroad.com/l/yoxqoc)**

---

## Tech Stack

- Laravel 12 / PHP 8.2+
- Laravel Sanctum (authentication)
- RESTful API
- SQLite / MySQL / PostgreSQL

## Frontend Repository

[heapadmin-dashboard](https://github.com/Peter29-heap/heapadmin-dashboard)

## Quick Setup

```bash
git clone https://github.com/Peter29-heap/heapadmin-api
cd heapadmin-api
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```
