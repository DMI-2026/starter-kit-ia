# Guía para docentes

Esta sección es para el profesor, no para los alumnos.

## Qué evidencia deja cada práctica

| Evidencia | Dónde | Qué revisar |
| --- | --- | --- |
| Bitácora de aprendizaje | `docs/bitacora-ia.md` | Una entrada por tarea: conceptos, qué escribió el alumno, qué escribió el agente y dudas |
| Artefactos del change | `openspec/changes/` y `openspec/changes/archive/` | Que la implementación coincida con las specs y que se haya hecho `verify` |
| Historial de git | Commits del alumno | Commits pequeños y frecuentes, no un solo commit al final |
| Reglas del agente | `AGENTS.md` | Que sea idéntico a [`plantilla/AGENTS.md`](plantilla/AGENTS.md) |

Comprobaciones rápidas desde la raíz del repositorio del alumno:

```bash
# ¿El AGENTS.md es el oficial? (sin salida = idéntico)
curl -fsSL https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main/plantilla/AGENTS.md | diff - AGENTS.md

# ¿Cómo evolucionó la bitácora y quién la tocó?
git log --format="%h %ad %an %s" --date=iso -- docs/bitacora-ia.md

# ¿Se editaron entradas anteriores? (el AGENTS.md prohíbe hacerlo)
git log -p --follow -- docs/bitacora-ia.md
```

**Señal de alerta:** la bitácora se escribió de golpe en un solo commit al final,
o se borraron o cambiaron entradas anteriores.

## Proteger el historial en GitHub

Un commit local se puede reescribir (`git commit --amend`, `git rebase`,
`git reset`) antes de hacer push, e incluso se le puede cambiar la fecha. Lo que
ya está en GitHub solo se puede reescribir con un **force-push**. Bloquearlo
hace que lo que ya subió sea permanente.

### Situación actual de la organización

La organización **DMI-2026 está en el plan Free**. En ese plan:

| Tipo de regla | ¿Disponible en Free? |
| --- | --- |
| Regla para **toda la organización** | No, requiere GitHub Team |
| Regla por repositorio **público** | Sí |
| Regla por repositorio **privado** | No, requiere GitHub Team |

Los profesores verificados en [GitHub Education](https://github.com/education/teachers)
pueden solicitar beneficios para la organización de su curso. Revisa si incluyen
GitHub Team antes de pagarlo.

### Opción A: una regla para toda la organización (requiere Team)

Bloquea el force-push y el borrado de ramas en **todos** los repositorios de la
organización:

```bash
gh api -X POST orgs/DMI-2026/rulesets --input - <<'EOF'
{
  "name": "Proteger historial de prácticas",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": { "include": ["~ALL"], "exclude": [] },
    "repository_name": { "include": ["~ALL"], "exclude": [] }
  },
  "rules": [{ "type": "non_fast_forward" }, { "type": "deletion" }]
}
EOF
```

### Opción B: una regla por repositorio público (funciona en Free)

Sustituye `<repo>` por el nombre del repositorio:

```bash
gh api -X POST repos/DMI-2026/<repo>/rulesets --input - <<'EOF'
{
  "name": "Proteger historial de prácticas",
  "target": "branch",
  "enforcement": "active",
  "conditions": { "ref_name": { "include": ["~ALL"], "exclude": [] } },
  "rules": [{ "type": "non_fast_forward" }, { "type": "deletion" }]
}
EOF
```

**Consecuencia:** los alumnos tampoco podrán borrar sus ramas después de
fusionarlas. Si eso estorba, quita `{ "type": "deletion" }` y deja solo
`non_fast_forward`.

### Sin reglas

Aunque no haya reglas, GitHub guarda en la página **Activity** de cada
repositorio (`https://github.com/DMI-2026/<repo>/activity`) los push y los
force-push, con su fecha. Revísala si sospechas que se reescribió el historial.

## Límite de todo esto

Ninguna medida impide que el alumno edite la bitácora antes de hacer commit, o
que cambie su `AGENTS.md`. La validación de fondo es la **revisión oral**: elige
dos o tres entradas de la bitácora y pídele que explique esa parte del código
frente a ti.
