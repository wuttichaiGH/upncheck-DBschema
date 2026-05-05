-- ==============================
-- tb_config
-- ==============================
CREATE TABLE tb_config (
  config_id int NOT NULL,
  apiUrl varchar(255) NOT NULL,
  usedApi enum('Piston','Judge0') NOT NULL,
  mode tinyint NOT NULL,
  PRIMARY KEY (config_id)
);

-- ==============================
-- tb_users
-- ==============================
CREATE TABLE tb_users (
  user_id int NOT NULL,
  username varchar(100) NOT NULL,
  email varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  fname varchar(100) NOT NULL DEFAULT '',
  lname varchar(100) NOT NULL DEFAULT '',
  pic_url varchar(255) NOT NULL DEFAULT 'assets/default.jpg',
  role enum('user','admin','superuser') DEFAULT 'user',
  PRIMARY KEY (user_id)
);

-- ==============================
-- tb_problems (อัพเดท: เพิ่ม category, created_by, source_type)
-- ==============================
CREATE TABLE tb_problems (
  problem_id int NOT NULL,
  title varchar(255) NOT NULL,
  description text NOT NULL,
  pdf_path varchar(255) NOT NULL DEFAULT '',
  max_score int NOT NULL DEFAULT 10,
  send_limit int NOT NULL DEFAULT 100,
  status tinyint NOT NULL DEFAULT 1,
  category varchar(255) DEFAULT NULL,           -- ✅ เพิ่มใหม่
  created_by int DEFAULT NULL,                   -- ✅ เพิ่มใหม่
  source_type enum('system','user') DEFAULT 'user', -- ✅ เพิ่มใหม่
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (problem_id),
  KEY fk_created_by (created_by),
  CONSTRAINT fk_created_by FOREIGN KEY (created_by)
    REFERENCES tb_users (user_id) ON DELETE SET NULL
);

-- ==============================
-- tb_registrations
-- ==============================
CREATE TABLE tb_registrations (
  registration_id int NOT NULL,
  fname_eng varchar(100) NOT NULL,
  lname_eng varchar(100) NOT NULL,
  fname varchar(100) NOT NULL,
  lname varchar(100) NOT NULL,
  email varchar(255) NOT NULL,
  school_name varchar(255) NOT NULL,
  username varchar(100) NOT NULL,
  password varchar(255) NOT NULL,
  status enum('pending','approved','rejected') DEFAULT 'pending',
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (registration_id)
);

-- ==============================
-- tb_submissions
-- ==============================
CREATE TABLE tb_submissions (
  submission_id int NOT NULL,
  user_id int NOT NULL,
  problem_id int NOT NULL,
  language text NOT NULL,
  file_path varchar(255) NOT NULL,
  submitted_at timestamp NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (submission_id),
  CONSTRAINT fk_submissions_users FOREIGN KEY (user_id)
    REFERENCES tb_users (user_id) ON DELETE CASCADE,
  CONSTRAINT fk_submissions_problems FOREIGN KEY (problem_id)
    REFERENCES tb_problems (problem_id) ON DELETE CASCADE
);

-- ==============================
-- tb_testcases
-- ==============================
CREATE TABLE tb_testcases (
  testcase_id int NOT NULL,
  problem_id int NOT NULL,
  input_data text NOT NULL,
  expected_output text NOT NULL,
  PRIMARY KEY (testcase_id),
  CONSTRAINT fk_testcases_problems FOREIGN KEY (problem_id)
    REFERENCES tb_problems (problem_id) ON DELETE CASCADE
);

-- ==============================
-- tb_scores
-- ==============================
CREATE TABLE tb_scores (
  score_id int NOT NULL,
  user_id int NOT NULL,
  problem_id int NOT NULL,
  submission_id int NOT NULL,
  score float NOT NULL,
  submitted_at timestamp NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (score_id),
  CONSTRAINT fk_scores_users FOREIGN KEY (user_id)
    REFERENCES tb_users (user_id) ON DELETE CASCADE,
  CONSTRAINT fk_scores_problems FOREIGN KEY (problem_id)
    REFERENCES tb_problems (problem_id) ON DELETE CASCADE,
  CONSTRAINT fk_scores_submissions FOREIGN KEY (submission_id)
    REFERENCES tb_submissions (submission_id) ON DELETE CASCADE
);

-- ==============================
-- tb_submission_testcases
-- ==============================
CREATE TABLE tb_submission_testcases (
  submission_testcase_id int NOT NULL,
  submission_id int NOT NULL,
  testcase_id int NOT NULL,
  output varchar(255) DEFAULT NULL,
  error varchar(255) DEFAULT '',
  is_passed tinyint NOT NULL,
  score decimal(10,0) NOT NULL,
  PRIMARY KEY (submission_testcase_id),
  CONSTRAINT fk_sub_test_sub FOREIGN KEY (submission_id)
    REFERENCES tb_submissions (submission_id) ON DELETE CASCADE,
  CONSTRAINT fk_sub_test_testcase FOREIGN KEY (testcase_id)
    REFERENCES tb_testcases (testcase_id) ON DELETE CASCADE
);
