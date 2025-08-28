/* ============================================================
   🔹 Trigger Timing in SQL Server

   1) AFTER Triggers
      - Run AFTER the standard operation (INSERT, UPDATE, DELETE).
      - Example: AFTER DELETE
          Step 1: Row is deleted.
          Step 2: Trigger runs.
      - If trigger fails → the whole action is rolled back.

   2) INSTEAD OF Triggers
      - Run IN PLACE of the standard operation.
      - Example: INSTEAD OF DELETE
          Step 1: SQL skips deleting the row.
          Step 2: Trigger code runs (you define what happens).
      - Common use cases:
          • Soft deletes (mark inactive instead of removing).
          • Allowing modifications on views.
          • Adding custom validation before changes.

   👉 Summary:
      - AFTER = action happens first, then trigger fires.
      - INSTEAD OF = action never happens, trigger code replaces it.
   ============================================================ */