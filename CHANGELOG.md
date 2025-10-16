# Changelog

All notable changes to the AnyCable Helm Chart will be documented in this file.

## [0.7.0]

### Changed
- **Breaking: Minimal supported Kubernetes version is 1.23**

- **Breaking: Ingress configuration structure completely refactored**
  - `ingress.enable` → `ingress.enabled` (for consistency)
  - Removed complex `ingress.acme.hosts` and `ingress.nonAcme.hosts` structure
  - Replaced with standard `ingress.hosts[]` array with `host` and `paths[]`
  - Removed `ingress.path` (now per-host in `paths[]`)
  - `ingress.tls[]` now optional when `acme.enabled: true` (auto-generated)

- **values.yaml updates**
  - Updated default image tag: `1.6.3` → `1.6.6`
  - Changed `replicas`: `1` → `2` (better default for HA)
  - Removed deprecated ACME ingress structure
  - Added simplified ingress configuration with ACME switch

### Migration Guide

Ingress Configuration

**Before (v0.6.1):**
```yaml
ingress:
  enable: true
  path: /cable
  acme:
    hosts:
      - anycable.example.com
  nonAcme:
    hosts:
      - secretName: example-tls
        names:
          - anycable.example.com
        tls:
          crt: ""
          key: ""
```

**After (v0.7.0):**
```yaml
ingress:
  enabled: true
  acme:
    enabled: true
  hosts:
    - host: anycable.example.com
      paths:
        - path: /cable
```

---

## [0.6.1] - Previous Releases

See git history for changes in v0.6.1 and earlier releases.
