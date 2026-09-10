---
tags:
  - mamba-package-manager
  - conda-package-manager
  - package-managers
  - mlops
---

---

|**Command**|**Why use it?**|
|---|---|
|`mamba create`|Use this for 10x faster environment creation when dealing with large GPU/Quantum libraries.|
|`mamba repoquery`|A "Principal-level" tool to view complex dependency trees (e.g., `mamba repoquery depends -f qiskit`).|
|`conda config --set solver libmamba`|(Optional) This makes `conda` use the fast mamba logic even if you forget and type `conda install`.|

---

| **Feature**    | **mamba update mamba --all**                     | **mamba update --all**                   |
| -------------- | ------------------------------------------------ | ---------------------------------------- |
| **Focus**      | Prioritizes the manager itself first.            | Treats all packages equally.             |
| **Safety**     | High (prevents using an old solver on new pkgs). | Standard.                                |
| **Use Case**   | Routine maintenance of the `base` environment.   | Updating a specific project environment. |
| **Redundancy** | Technically redundant (but safer).               | Clean and direct.                        |

---

