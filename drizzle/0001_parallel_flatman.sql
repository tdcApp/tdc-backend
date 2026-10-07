ALTER TABLE "users" RENAME COLUMN "id" TO "firebase_uid";--> statement-breakpoint
ALTER TABLE "announcements" DROP CONSTRAINT "announcements_created_by_users_id_fk";
--> statement-breakpoint
ALTER TABLE "assignment_submissions" DROP CONSTRAINT "assignment_submissions_mentee_uid_users_id_fk";
--> statement-breakpoint
ALTER TABLE "classes" DROP CONSTRAINT "classes_mentor_uid_users_id_fk";
--> statement-breakpoint
ALTER TABLE "quiz_submissions" DROP CONSTRAINT "quiz_submissions_student_uid_users_id_fk";
--> statement-breakpoint
ALTER TABLE "quizzes" DROP CONSTRAINT "quizzes_created_by_users_id_fk";
--> statement-breakpoint
ALTER TABLE "schedules" DROP CONSTRAINT "schedules_teacher_uid_users_id_fk";
--> statement-breakpoint
ALTER TABLE "announcements" ADD CONSTRAINT "announcements_created_by_users_firebase_uid_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("firebase_uid") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_mentee_uid_users_firebase_uid_fk" FOREIGN KEY ("mentee_uid") REFERENCES "public"."users"("firebase_uid") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "classes" ADD CONSTRAINT "classes_mentor_uid_users_firebase_uid_fk" FOREIGN KEY ("mentor_uid") REFERENCES "public"."users"("firebase_uid") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "quiz_submissions" ADD CONSTRAINT "quiz_submissions_student_uid_users_firebase_uid_fk" FOREIGN KEY ("student_uid") REFERENCES "public"."users"("firebase_uid") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "quizzes" ADD CONSTRAINT "quizzes_created_by_users_firebase_uid_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("firebase_uid") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "schedules" ADD CONSTRAINT "schedules_teacher_uid_users_firebase_uid_fk" FOREIGN KEY ("teacher_uid") REFERENCES "public"."users"("firebase_uid") ON DELETE restrict ON UPDATE cascade;