CREATE TABLE `tb_config` (
  `config_id` int(1) NOT NULL,
  `apiUrl` varchar(255) NOT NULL,
  `usedApi` enum('Piston','Judge0') NOT NULL,
  `mode` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tb_problems` (
  `problem_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `pdf_path` varchar(255) NOT NULL DEFAULT '',
  `max_score` int(3) NOT NULL DEFAULT 10,
  `send_limit` int(3) NOT NULL DEFAULT 100,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tb_registrations` (
  `registration_id` int(11) NOT NULL,
  `fname_eng` varchar(100) NOT NULL,
  `lname_eng` varchar(100) NOT NULL,
  `fname` varchar(100) NOT NULL,
  `lname` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `school_name` varchar(255) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tb_scores` (
  `score_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `problem_id` int(11) NOT NULL,
  `submission_id` int(11) NOT NULL,
  `score` float(5,2) NOT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tb_submissions` (
  `submission_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `problem_id` int(11) NOT NULL,
  `language` text NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tb_submission_testcases` (
  `submission_testcase_id` int(11) NOT NULL,
  `submission_id` int(11) NOT NULL,
  `testcase_id` int(11) NOT NULL,
  `output` varchar(255) DEFAULT NULL,
  `error` varchar(255) DEFAULT '',
  `is_passed` tinyint(1) NOT NULL,
  `score` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tb_testcases` (
  `testcase_id` int(11) NOT NULL,
  `problem_id` int(11) NOT NULL,
  `input_data` text NOT NULL,
  `expected_output` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tb_users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fname` varchar(100) NOT NULL DEFAULT '',
  `lname` varchar(100) NOT NULL DEFAULT '',
  `pic_url` varchar(255) NOT NULL DEFAULT 'assets/default.jpg',
  `role` enum('user','admin','superuser') DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes & Primary Keys
ALTER TABLE `tb_config` ADD PRIMARY KEY (`config_id`);
ALTER TABLE `tb_problems` ADD PRIMARY KEY (`problem_id`);
ALTER TABLE `tb_registrations` ADD PRIMARY KEY (`registration_id`);
ALTER TABLE `tb_users` ADD PRIMARY KEY (`user_id`);

ALTER TABLE `tb_scores`
  ADD PRIMARY KEY (`score_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `problem_id` (`problem_id`),
  ADD KEY `submission_id` (`submission_id`);

ALTER TABLE `tb_submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `problem_id` (`problem_id`);

ALTER TABLE `tb_submission_testcases`
  ADD PRIMARY KEY (`submission_testcase_id`),
  ADD KEY `submission_id` (`submission_id`),
  ADD KEY `testcase_id` (`testcase_id`);

ALTER TABLE `tb_testcases`
  ADD PRIMARY KEY (`testcase_id`),
  ADD KEY `problem_id` (`problem_id`);

-- Constraints (Foreign Keys)
ALTER TABLE `tb_scores`
  ADD CONSTRAINT `tb_scores_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tb_scores_ibfk_2` FOREIGN KEY (`problem_id`) REFERENCES `tb_problems` (`problem_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tb_scores_ibfk_3` FOREIGN KEY (`submission_id`) REFERENCES `tb_submissions` (`submission_id`) ON DELETE CASCADE;

ALTER TABLE `tb_submissions`
  ADD CONSTRAINT `tb_submissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tb_submissions_ibfk_2` FOREIGN KEY (`problem_id`) REFERENCES `tb_problems` (`problem_id`) ON DELETE CASCADE;

ALTER TABLE `tb_submission_testcases`
  ADD CONSTRAINT `tb_submission_testcases_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `tb_submissions` (`submission_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tb_submission_testcases_ibfk_2` FOREIGN KEY (`testcase_id`) REFERENCES `tb_testcases` (`testcase_id`) ON DELETE CASCADE;

ALTER TABLE `tb_testcases`
  ADD CONSTRAINT `tb_testcases_ibfk_1` FOREIGN KEY (`problem_id`) REFERENCES `tb_problems` (`problem_id`) ON DELETE CASCADE;