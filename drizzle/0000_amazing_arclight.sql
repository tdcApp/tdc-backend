CREATE TYPE "public"."audience" AS ENUM('ALL', 'LANGUAGE', 'TECHNOLOGY', 'CLASS');--> statement-breakpoint
CREATE TYPE "public"."class_type" AS ENUM('LANGUAGE', 'TECHNOLOGY');--> statement-breakpoint
CREATE TYPE "public"."user_role" AS ENUM('STUDENT', 'TEACHER', 'ADMIN');--> statement-breakpoint
CREATE TABLE "announcements" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"title" varchar(255) NOT NULL,
	"content" text NOT NULL,
	"audience" "audience" NOT NULL,
	"class_id" uuid,
	"created_by" varchar(128) NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "announcement_audience_class_consistency" CHECK (
        (
          "announcements"."audience" = 'CLASS'
          AND "announcements"."class_id" IS NOT NULL
        )
        OR
        (
          "announcements"."audience" <> 'CLASS'
          AND "announcements"."class_id" IS NULL
        )
      )
);
--> statement-breakpoint
CREATE TABLE "assignment_submissions" (
	"assignment_id" uuid NOT NULL,
	"mentee_uid" varchar(128) NOT NULL,
	"submission_url" text NOT NULL,
	"submitted_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "assignment_submissions_pk" PRIMARY KEY("assignment_id","mentee_uid")
);
--> statement-breakpoint
CREATE TABLE "assignments" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"title" varchar(255) NOT NULL,
	"description" text,
	"class_id" uuid NOT NULL,
	"due_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "classes" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" varchar(100) NOT NULL,
	"type" "class_type" NOT NULL,
	"mentor_uid" varchar(128) NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "classes_name_type_unique" UNIQUE("name","type")
);
--> statement-breakpoint
CREATE TABLE "quiz_questions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"quiz_id" uuid NOT NULL,
	"question" text NOT NULL,
	"option_a" text NOT NULL,
	"option_b" text NOT NULL,
	"option_c" text NOT NULL,
	"option_d" text NOT NULL,
	"correct_option" varchar(1) NOT NULL,
	"question_order" integer NOT NULL,
	CONSTRAINT "quiz_questions_order_unique" UNIQUE("quiz_id","question_order"),
	CONSTRAINT "quiz_question_correct_option_check" CHECK (
        "quiz_questions"."correct_option" IN ('A', 'B', 'C', 'D')
      ),
	CONSTRAINT "quiz_question_order_positive_check" CHECK (
        "quiz_questions"."question_order" > 0
      )
);
--> statement-breakpoint
CREATE TABLE "quiz_submissions" (
	"quiz_id" uuid NOT NULL,
	"student_uid" varchar(128) NOT NULL,
	"score" integer NOT NULL,
	"total_questions" integer NOT NULL,
	"client_submission_id" uuid NOT NULL,
	"submitted_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "quiz_submissions_pk" PRIMARY KEY("quiz_id","student_uid"),
	CONSTRAINT "quiz_submissions_client_submission_id_unique" UNIQUE("client_submission_id"),
	CONSTRAINT "quiz_submission_score_non_negative" CHECK ("quiz_submissions"."score" >= 0),
	CONSTRAINT "quiz_submission_total_questions_positive" CHECK ("quiz_submissions"."total_questions" > 0),
	CONSTRAINT "quiz_submission_score_valid" CHECK (
        "quiz_submissions"."score" <= "quiz_submissions"."total_questions"
      )
);
--> statement-breakpoint
CREATE TABLE "quizzes" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"title" varchar(255) NOT NULL,
	"audience" "audience" NOT NULL,
	"class_id" uuid,
	"created_by" varchar(128) NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "quiz_audience_class_consistency" CHECK (
        (
          "quizzes"."audience" = 'CLASS'
          AND "quizzes"."class_id" IS NOT NULL
        )
        OR
        (
          "quizzes"."audience" <> 'CLASS'
          AND "quizzes"."class_id" IS NULL
        )
      )
);
--> statement-breakpoint
CREATE TABLE "schedules" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"class_id" uuid NOT NULL,
	"day_of_week" integer NOT NULL,
	"start_time" time NOT NULL,
	"end_time" time NOT NULL,
	"subject" varchar(255) NOT NULL,
	"room" varchar(100),
	"teacher_uid" varchar(128) NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "schedule_day_of_week_check" CHECK (
        "schedules"."day_of_week" BETWEEN 0 AND 6
      ),
	CONSTRAINT "schedule_time_check" CHECK (
        "schedules"."end_time" > "schedules"."start_time"
      )
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" varchar(128) PRIMARY KEY NOT NULL,
	"email" varchar(255) NOT NULL,
	"name" varchar(255) NOT NULL,
	"role" "user_role" DEFAULT 'STUDENT' NOT NULL,
	"language_class_id" uuid,
	"technology_class_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "announcements" ADD CONSTRAINT "announcements_class_id_classes_id_fk" FOREIGN KEY ("class_id") REFERENCES "public"."classes"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "announcements" ADD CONSTRAINT "announcements_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_assignment_id_assignments_id_fk" FOREIGN KEY ("assignment_id") REFERENCES "public"."assignments"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_mentee_uid_users_id_fk" FOREIGN KEY ("mentee_uid") REFERENCES "public"."users"("id") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_class_id_classes_id_fk" FOREIGN KEY ("class_id") REFERENCES "public"."classes"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "classes" ADD CONSTRAINT "classes_mentor_uid_users_id_fk" FOREIGN KEY ("mentor_uid") REFERENCES "public"."users"("id") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "quiz_questions" ADD CONSTRAINT "quiz_questions_quiz_id_quizzes_id_fk" FOREIGN KEY ("quiz_id") REFERENCES "public"."quizzes"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "quiz_submissions" ADD CONSTRAINT "quiz_submissions_quiz_id_quizzes_id_fk" FOREIGN KEY ("quiz_id") REFERENCES "public"."quizzes"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "quiz_submissions" ADD CONSTRAINT "quiz_submissions_student_uid_users_id_fk" FOREIGN KEY ("student_uid") REFERENCES "public"."users"("id") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "quizzes" ADD CONSTRAINT "quizzes_class_id_classes_id_fk" FOREIGN KEY ("class_id") REFERENCES "public"."classes"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "quizzes" ADD CONSTRAINT "quizzes_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "schedules" ADD CONSTRAINT "schedules_class_id_classes_id_fk" FOREIGN KEY ("class_id") REFERENCES "public"."classes"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "schedules" ADD CONSTRAINT "schedules_teacher_uid_users_id_fk" FOREIGN KEY ("teacher_uid") REFERENCES "public"."users"("id") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_language_class_id_classes_id_fk" FOREIGN KEY ("language_class_id") REFERENCES "public"."classes"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_technology_class_id_classes_id_fk" FOREIGN KEY ("technology_class_id") REFERENCES "public"."classes"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
CREATE INDEX "announcements_class_idx" ON "announcements" USING btree ("class_id");--> statement-breakpoint
CREATE INDEX "announcements_created_by_idx" ON "announcements" USING btree ("created_by");--> statement-breakpoint
CREATE INDEX "announcements_audience_idx" ON "announcements" USING btree ("audience");--> statement-breakpoint
CREATE INDEX "assignment_submissions_mentee_idx" ON "assignment_submissions" USING btree ("mentee_uid");--> statement-breakpoint
CREATE INDEX "assignments_class_idx" ON "assignments" USING btree ("class_id");--> statement-breakpoint
CREATE INDEX "assignments_due_at_idx" ON "assignments" USING btree ("due_at");--> statement-breakpoint
CREATE INDEX "classes_mentor_idx" ON "classes" USING btree ("mentor_uid");--> statement-breakpoint
CREATE INDEX "quiz_questions_quiz_idx" ON "quiz_questions" USING btree ("quiz_id");--> statement-breakpoint
CREATE INDEX "quiz_submissions_student_idx" ON "quiz_submissions" USING btree ("student_uid");--> statement-breakpoint
CREATE INDEX "quizzes_class_idx" ON "quizzes" USING btree ("class_id");--> statement-breakpoint
CREATE INDEX "quizzes_created_by_idx" ON "quizzes" USING btree ("created_by");--> statement-breakpoint
CREATE INDEX "quizzes_audience_idx" ON "quizzes" USING btree ("audience");--> statement-breakpoint
CREATE INDEX "schedules_class_idx" ON "schedules" USING btree ("class_id");--> statement-breakpoint
CREATE INDEX "schedules_teacher_idx" ON "schedules" USING btree ("teacher_uid");--> statement-breakpoint
CREATE INDEX "schedules_day_idx" ON "schedules" USING btree ("day_of_week");--> statement-breakpoint
CREATE INDEX "users_language_class_idx" ON "users" USING btree ("language_class_id");--> statement-breakpoint
CREATE INDEX "users_technology_class_idx" ON "users" USING btree ("technology_class_id");--> statement-breakpoint
CREATE INDEX "users_role_idx" ON "users" USING btree ("role");