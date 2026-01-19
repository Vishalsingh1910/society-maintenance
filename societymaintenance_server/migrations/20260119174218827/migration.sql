BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "announcement" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "body" text NOT NULL,
    "createdByUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "attachmentUrl" text
);

-- Indexes
CREATE INDEX "announcement_created_at_idx" ON "announcement" USING btree ("createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "announcement_read" (
    "id" bigserial PRIMARY KEY,
    "announcementId" bigint NOT NULL,
    "userId" uuid NOT NULL,
    "readAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "announcement_read_unique_idx" ON "announcement_read" USING btree ("announcementId", "userId");
CREATE INDEX "announcement_read_user_id_idx" ON "announcement_read" USING btree ("userId");


--
-- MIGRATION VERSION FOR societymaintenance
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('societymaintenance', '20260119174218827', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260119174218827', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
