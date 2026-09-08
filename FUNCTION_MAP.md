# Project Function Map: LOCAL-MI-RESEARCH
> It is STRICTLY PROHIBITED to write above this line. Start text from under this line

## v0.5 exact function-definition coverage — source-derived inventory (documentation-only)

**Census receipt.** A fresh stable on-disk AST reparse finds 1,160 definitions across 110 files: 719 in 94 source files and 441 in 16 test files. The inventory is regenerated from the current bytes after the M3 vocabulary and ACDC closed-schema repairs, candidate rebind, exact ACDC batch identity binding, nested-derived-field refusal, direct-join completeness, legacy-facade binding, runner-result control hardening, reconciliation-closure hardening, sealed direct-cell carrier enforcement, forged-batch refusal-test expansion, source-record closure hardening, direct-ACDC caller-field projection hardening, C14 artifact marker/recovery/no-clobber repairs, C14 symlink/path-boundary repairs, C14 descriptor-anchored TOCTOU repairs, C14 pre-creation directory-admission repairs, executor-boundary uncertainty handling, ACDC exception-redaction repairs, executor-phase extraction, exception-redaction assertion factoring, closed executor-result projection, direct-ACDC exception redaction, terminal-reason semantics, versioned six-trigger cap settlement, stop-loss API-surface separation, and settlement-reference version-isolation hardening.

**Deterministic method.** The census is exactly `src/phase3/*modal_v05*.py` plus `testing/test_modal_v05_*.py`, parsed as UTF-8 with Python's standard-library `ast` parser. Every `FunctionDef` and `AsyncFunctionDef` returned by a recursive AST walk is listed, including class methods and nested definitions. Files are ordered by exact relative POSIX path; definitions are ordered by source line, column, and qualified name. Zero-definition files remain explicit closure rows. The source-census digest is `8fc4bdb6ab7812a7f02bc6c08e50f69776cb67231f412796443ded42ad529bd9`, computed as SHA-256 over the 94 sorted source-file path<TAB>file_sha256<TAB>definition_count<LF> rows.

**Claim boundary.** This is documentation coverage only. It does not assert code-complete, operational, admission, runtime, execution, experiment, result, review, or overall-readiness status.

**Source definitions — 719 across 94 files.**

### `src/phase3/_modal_v05_track1_identity_constants.py` — **1 definition(s)**
Registered constants and refusal type for candidate identity checks.

- `IdentityContractError.__init__` (L81) — Initializes the enclosing exception or object fields; performs the source-defined update/validation

### `src/phase3/_modal_v05_track1_identity_encoding.py` — **14 definition(s)**
Exact byte and length-framed identity record parsing.

- `_refuse` (L20) — Constructs the typed refusal for the supplied value; returns the derived value to its caller
- `_read_regular` (L24) — Reads regular; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `sha256_file` (L53) — Hash one exact regular file without following a final symlink.; direct in-census collaborators: `_read_regular`; returns the derived value to its caller
- `_sha256` (L59) — Derives the SHA-256 digest for the supplied value; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_decode_ascii` (L68) — Decodes ascii; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_read_length` (L75) — Reads length; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_read_outer_field` (L95) — Reads outer field; direct in-census collaborators: `_read_length`, `_refuse`, `_decode_ascii`; contains explicit exception/refusal paths
- `_read_nested_field` (L114) — Reads nested field; direct in-census collaborators: `_read_length`, `_refuse`, `_decode_ascii`; contains explicit exception/refusal paths
- `_parse_map_payload` (L141) — Parses map payload; direct in-census collaborators: `_refuse`, `_read_nested_field`; contains explicit exception/refusal paths
- `_parse_ordered_list` (L169) — Parses ordered list; direct in-census collaborators: `_refuse`, `_read_length`, `_parse_map_payload`; contains explicit exception/refusal paths
- `_parse_record` (L209) — Parses record; direct in-census collaborators: `_refuse`, `_decode_ascii`, `_read_outer_field`; contains explicit exception/refusal paths
- `_field` (L255) — Extracts the supplied value; direct in-census collaborators: `_refuse`, `_decode_ascii`; contains explicit exception/refusal paths
- `_require_hash` (L274) — Validates hash; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_field_map` (L282) — Extracts map; direct in-census collaborators: `_refuse`, `_require_hash`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track1_identity_paths.py` — **6 definition(s)**
Project-root, path, live-hash, and bundle-preimage identity checks.

- `_canonical_input_paths` (L22) — Derives canonical input paths; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_find_project_root` (L34) — Finds project root; direct in-census collaborators: `_canonical_input_paths`, `_refuse`; contains explicit exception/refusal paths
- `_declared_identity_paths` (L65) — Resolves identity paths; direct in-census collaborators: `_parse_ordered_list`, `_field_map`, `_refuse`; contains explicit exception/refusal paths
- `_resolve_identity_paths` (L107) — Resolves identity paths; direct in-census collaborators: `_find_project_root`, `_refuse`, `_canonical_input_paths`; contains explicit exception/refusal paths
- `_live_identity_hashes` (L140) — Checks live identity hashes; direct in-census collaborators: `sha256_file`, `_canonical_input_paths`, `_refuse`; contains explicit exception/refusal paths
- `_bundle_preimage` (L166) — Derives/validates the bundle preimage value for the enclosing module contract; direct in-census collaborators: `_sha256`, `_refuse`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track1_identity_sidecar.py` — **6 definition(s)**
Sidecar block, reference, and identity-record validation.

- `_extract_identity_blocks` (L33) — Derives/validates the extract identity blocks value for the enclosing module contract; direct in-census collaborators: `_refuse`, `_decode_ascii`; contains explicit exception/refusal paths
- `_wrapper_members` (L58) — Extracts members; direct in-census collaborators: `_refuse`, `_decode_ascii`, `_require_hash`; contains explicit exception/refusal paths
- `_external_hashes` (L88) — Extracts hashes; direct in-census collaborators: `_refuse`, `_decode_ascii`; contains explicit exception/refusal paths
- `_record_fields` (L115) — Builds/extracts fields; direct in-census collaborators: `_decode_ascii`; returns the derived value to its caller
- `_parse_identity_records` (L122) — Parses identity records; direct in-census collaborators: `_extract_identity_blocks`, `_sha256`, `_external_hashes`, `_refuse`; contains explicit exception/refusal paths
- `_identity_record_fields` (L176) — Derives identity for record fields; direct in-census collaborators: `_record_fields`, `_refuse`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track1_identity_validation.py` — **4 definition(s)**
Cross-file candidate, bundle, and sidecar identity closure.

- `_validate_bundle_identity` (L26) — Validates bundle identity; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_validate_candidate_identity` (L50) — Validates candidate identity; direct in-census collaborators: `_sha256`, `_refuse`; contains explicit exception/refusal paths
- `_identity_result` (L76) — Derives identity for result; returns the derived value to its caller
- `reconstruct_candidate_identity` (L116) — Reconstruct and verify the exact wrapper/sidecar/member/context identity.; direct in-census collaborators: `_read_regular`, `_sha256`, `_wrapper_members`, `_parse_identity_records`; returns the derived value to its caller

### `src/phase3/_modal_v05_track1_pair_acdc.py` — **3 definition(s)**
Compatibility adapter that routes the legacy ACDC entry point through canonical full-census admission.

- `_legacy_digest` (L21) — Internal helper for the source-defined contract.
- `_legacy_result` (L44) — Internal helper for the source-defined contract.
- `build_fixed_acdc_batch` (L78) — Build the legacy-shaped result only after canonical full-census admission.; returns the derived value to its caller

### `src/phase3/_modal_v05_track1_pair_constants.py` — **11 definition(s)**
Canonical pair identity primitives shared by the v0.5 pair facades.

- `PairContractError.__init__` (L32) — Initializes the enclosing exception or object fields; performs the source-defined update/validation
- `_field` (L37) — Extracts the supplied value; contains explicit exception/refusal paths
- `_component` (L53) — Extracts the supplied value; direct in-census collaborators: `_field`; contains explicit exception/refusal paths
- `_block` (L73) — Extracts the supplied value; direct in-census collaborators: `_field`; contains explicit exception/refusal paths
- `_tuple_values` (L82) — Builds/extracts values; direct in-census collaborators: `_block`, `_component`; contains explicit exception/refusal paths
- `canonical_pair_key` (L92) — Return the exact lower-case, case-sensitive logical pair key.; direct in-census collaborators: `_tuple_values`; contains explicit exception/refusal paths
- `_byte_tuple` (L112) — Encodes tuple; returns the derived value to its caller
- `_occurrence_key` (L116) — Derives key; direct in-census collaborators: `integer`; returns the derived value to its caller
- `_occurrence_key.<locals>.integer` (L119) — Coerces the optional integer field; returns the derived value to its caller
- `_validate_draw_id` (L135) — Validates draw ID; contains explicit exception/refusal paths
- `_source_block` (L144) — Derives/validates the source block value for the enclosing module contract; direct in-census collaborators: `_field`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track1_pair_duplicates.py` — **8 definition(s)**
Exact and near-duplicate pair collapse with audit-row retention.

- `_near_edge` (L22) — Compares edge; direct in-census collaborators: `_jaccard`, `_three_grams`; returns the derived value to its caller
- `_exact_duplicate_groups` (L38) — Groups duplicate groups; returns the derived value to its caller
- `_resolve_exact_groups` (L48) — Resolves exact groups; direct in-census collaborators: `values`, `_pair_signature`, `_mark`, `_occurrence_key`; returns the derived value to its caller
- `_near_duplicate_graph` (L74) — Compares duplicate graph; direct in-census collaborators: `_near_edge`; returns the derived value to its caller
- `_near_duplicate_component` (L98) — Compares duplicate component; direct in-census collaborators: `_occurrence_key`; returns the derived value to its caller
- `_mark_near_duplicate_components` (L121) — Marks near duplicate components; direct in-census collaborators: `_near_duplicate_component`, `_occurrence_key`, `_mark`; performs the source-defined update/validation
- `_collapse_summary` (L146) — Collapses summary; returns the derived value to its caller
- `collapse_pair_duplicates` (L182) — Collapse exact/near duplicates globally while retaining every audit row.; direct in-census collaborators: `_flatten_rows`, `_standardise_row`, `_exact_duplicate_groups`, `_resolve_exact_groups`; returns the derived value to its caller

### `src/phase3/_modal_v05_track1_pair_members.py` — **10 definition(s)**
Deterministic ABBA/BABA member construction and token evidence helpers.

- `_coerce_token_ids` (L21) — Accepts only exact native integer token IDs; returns the derived value to its caller
- `_token_alias_ids` (L35) — Validates alias IDs; direct in-census collaborators: `_coerce_token_ids`; returns the derived value to its caller
- `_special_token_ids` (L52) — Extracts token IDs; direct in-census collaborators: `_coerce_token_ids`; returns the derived value to its caller
- `_member_token_ids` (L59) — Builds/extracts token IDs; direct in-census collaborators: `_token_alias_ids`, `_special_token_ids`; returns the derived value to its caller
- `_has_token_evidence` (L69) — Return whether a member explicitly carries token evidence. Token evidence is the one intentionally optional member field: a source row may omit it when no token IDs or tokenizer are registered. If any token alias, including ''special_token_ids'', is present, callers must validate the resulting sequence instead of treating it as absent.; returns the derived value to its caller
- `_three_grams` (L83) — Computes grams; direct in-census collaborators: `_member_token_ids`; returns the derived value to its caller
- `_jaccard` (L92) — Derives/validates the jaccard value for the enclosing module contract; returns the derived value to its caller
- `_call_tokenizer` (L101) — Calls tokenizer; direct in-census collaborators: `_coerce_token_ids`, `tokenizer`; returns the derived value to its caller
- `_member_common` (L117) — Builds/extracts common; returns the derived value to its caller
- `instantiate_pair_members` (L151) — Construct the immutable ABBA source and BABA target members.; direct in-census collaborators: `_tuple_values`, `canonical_pair_key`, `_member_common`, `_call_tokenizer`; returns the derived value to its caller

### `src/phase3/_modal_v05_track1_pair_rows.py` — **20 definition(s)**
Pair-row normalization shared by duplicate and ACDC predicates.

- `_flatten_rows` (L47) — Flattens rows; contains explicit exception/refusal paths
- `_members_from_row` (L63) — Extracts the ABBA/BABA members from the row; returns the derived value to its caller
- `_incomplete_pair` (L91) — Marks the pair as incomplete returns the derived value to its caller
- `_valid_row_ordinal` (L98) — Checks row ordinal; returns the derived value to its caller
- `_context_instance` (L106) — Validates instance; returns the derived value to its caller
- `_identity_value_matches` (L112) — Derives identity for value matches; returns the derived value to its caller
- `_context_values_match` (L116) — Validates values match; direct in-census collaborators: `_context_instance`, `_identity_value_matches`; returns the derived value to its caller
- `_validate_pair_input_ids` (L124) — Validates pair input IDs; contains explicit exception/refusal paths
- `_validate_pair_instance` (L136) — Validates pair instance; direct in-census collaborators: `_context_values_match`; contains explicit exception/refusal paths
- `_validate_pair_context` (L148) — Validates pair context; direct in-census collaborators: `_identity_value_matches`, `_validate_draw_id`, `_valid_row_ordinal`, `_validate_pair_instance`; contains explicit exception/refusal paths
- `_prepare_standard_row` (L186) — Prepares standard row; direct in-census collaborators: `canonical_pair_key`, `_block`, `_validate_pair_context`, `_incomplete_pair`; returns the derived value to its caller
- `_standard_members` (L200) — Normalizes members; direct in-census collaborators: `_members_from_row`, `instantiate_pair_members`; returns the derived value to its caller
- `_has_supplied_members` (L215) — Checks whether supplied members; returns the derived value to its caller
- `_member_token_mismatch` (L221) — Builds/extracts token mismatch; direct in-census collaborators: `_has_token_evidence`, `_member_token_ids`; returns the derived value to its caller
- `_optional_member_identity_mismatch` (L241) — Checks optional member identity mismatch; direct in-census collaborators: `_context_values_match`, `_identity_value_matches`; returns the derived value to its caller
- `_member_identity_mismatch` (L278) — Return the first immutable member mismatch, if any. Every canonical member field is required. Token evidence is the sole intentional omission: it may be absent when the source has no tokenizer evidence, but any supplied token alias must be independently comparable.; direct in-census collaborators: `_identity_value_matches`, `_optional_member_identity_mismatch`, `_member_token_mismatch`; returns the derived value to its caller
- `_members_match_key` (L316) — Builds/extracts match key; returns the derived value to its caller
- `_standardise_row` (L337) — Derives/validates the standardise row value for the enclosing module contract; direct in-census collaborators: `_prepare_standard_row`, `_has_supplied_members`, `_standard_members`, `_incomplete_pair`; returns the derived value to its caller
- `_pair_signature` (L379) — Derives/validates the pair signature value for the enclosing module contract; direct in-census collaborators: `_member_token_ids`; returns the derived value to its caller
- `_mark` (L395) — Marks the record; direct in-census collaborators: `values`; performs the source-defined update/validation

### `src/phase3/_modal_v05_track1_pair_sampling.py` — **7 definition(s)**
Route-B population validation, sampling, and pair-manifest construction.

- `_source_population` (L26) — Derives/validates the source population value for the enclosing module contract; contains explicit exception/refusal paths
- `_population_row` (L45) — Normalizes row; direct in-census collaborators: `_component`, `canonical_pair_key`; contains explicit exception/refusal paths
- `_normalise_population` (L92) — Normalizes population; direct in-census collaborators: `_population_row`, `_byte_tuple`; contains explicit exception/refusal paths
- `_sample_population` (L120) — Samples population; direct in-census collaborators: `_byte_tuple`; returns the derived value to its caller
- `_build_pair_record` (L135) — Builds pair record; direct in-census collaborators: `instantiate_pair_members`, `canonical_pair_key`; returns the derived value to its caller
- `_route_b_manifest` (L172) — Routes b manifest; direct in-census collaborators: `values`; returns the derived value to its caller
- `build_route_b_pair_manifest` (L193) — Sample one deterministic draw/block and construct all 15 pair members.; direct in-census collaborators: `_validate_draw_id`, `_source_block`, `_normalise_population`, `_source_population`; returns the derived value to its caller

### `src/phase3/_modal_v05_track1_semantic_constants.py` — **1 definition(s)**
Registered constants and refusal type for the semantic-chain contract.

- `SemanticContractError.__init__` (L171) — Initializes the enclosing exception or object fields; performs the source-defined update/validation

### `src/phase3/_modal_v05_track1_semantic_encoding.py` — **11 definition(s)**
Canonical byte parsing for S1 and amendment semantic records.

- `_read_bytes` (L17) — Reads bytes; contains explicit exception/refusal paths
- `_marked_block` (L32) — Derives/validates the marked block value for the enclosing module contract; contains explicit exception/refusal paths
- `_s1_preimage` (L57) — Derives/validates the S1 preimage value for the enclosing module contract; contains explicit exception/refusal paths
- `_read_uint` (L76) — Reads uint; contains explicit exception/refusal paths
- `_length_value` (L90) — Derives/validates the length value value for the enclosing module contract; direct in-census collaborators: `_read_uint`; contains explicit exception/refusal paths
- `_parse_s1` (L100) — Parses S1; direct in-census collaborators: `_length_value`; contains explicit exception/refusal paths
- `_amendment_version_line` (L146) — Derives/validates the amendment version line value for the enclosing module contract; returns the derived value to its caller
- `_validate_pipe_preamble` (L151) — Validates pipe preamble; direct in-census collaborators: `_amendment_version_line`; contains explicit exception/refusal paths
- `_parse_pipe_field` (L166) — Parses pipe field; contains explicit exception/refusal paths
- `_validate_pipe_fields` (L175) — Validates pipe fields; contains explicit exception/refusal paths
- `_parse_pipe` (L187) — Parses pipe; direct in-census collaborators: `_validate_pipe_preamble`, `_parse_pipe_field`, `_validate_pipe_fields`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track1_semantic_schema.py` — **8 definition(s)**
Schema declaration parsing and positional validation for amendments.

- `_parse_schema_row` (L14) — Parses schema row; contains explicit exception/refusal paths
- `_validate_schema_shape` (L23) — Validates schema shape; contains explicit exception/refusal paths
- `_validate_schema_ordinals` (L34) — Validates schema ordinals; contains explicit exception/refusal paths
- `_validate_schema_record_types` (L44) — Validates schema record types; contains explicit exception/refusal paths
- `_validate_schema_nullability_tokens` (L53) — Validates schema nullability tokens; contains explicit exception/refusal paths
- `_validate_schema_fields` (L62) — Validates schema fields; contains explicit exception/refusal paths
- `_validate_schema_nullability_positions` (L76) — Validates schema nullability positions; contains explicit exception/refusal paths
- `_parse_schema` (L88) — Parses schema; direct in-census collaborators: `_parse_schema_row`, `_validate_schema_shape`, `_validate_schema_ordinals`, `_validate_schema_record_types`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track1_semantic_validation.py` — **14 definition(s)**
Value, state, predecessor, and event-hash validation for the S1-S3 chain.

- `_expected` (L37) — Resolves expected the supplied value; returns the derived value to its caller
- `_require_sha` (L44) — Validates sha; contains explicit exception/refusal paths
- `_normalise_event_hash` (L51) — Normalizes event hash; returns the derived value to its caller
- `_validate_s1` (L55) — Validates S1; direct in-census collaborators: `_read_bytes`, `_s1_preimage`, `_parse_s1`, `_require_sha`; contains explicit exception/refusal paths
- `_read_amendment` (L105) — Reads amendment; direct in-census collaborators: `_read_bytes`, `_marked_block`, `_parse_schema`, `_parse_pipe`; returns the derived value to its caller
- `_validate_amendment_schema_binding` (L123) — Validates amendment schema binding; contains explicit exception/refusal paths
- `_validate_amendment_value` (L152) — Validates amendment value; contains explicit exception/refusal paths
- `_validate_amendment_values` (L172) — Validates amendment values; direct in-census collaborators: `_validate_amendment_value`; performs the source-defined update/validation
- `_validate_amendment_state` (L180) — Validates amendment state; direct in-census collaborators: `_require_sha`; contains explicit exception/refusal paths
- `_validate_amendment_predecessor` (L210) — Validates amendment predecessor; direct in-census collaborators: `_normalise_event_hash`; contains explicit exception/refusal paths
- `_validate_amendment_event_hash` (L222) — Validates amendment event hash; direct in-census collaborators: `_expected`, `_normalise_event_hash`; contains explicit exception/refusal paths
- `_validate_s3_pair_key` (L240) — Validates S3 pair key; direct in-census collaborators: `_expected`; contains explicit exception/refusal paths
- `_validate_amendment` (L260) — Validates amendment; direct in-census collaborators: `_read_amendment`, `_validate_amendment_schema_binding`, `_validate_amendment_values`, `_validate_amendment_state`; returns the derived value to its caller
- `validate_semantic_chain` (L291) — Validate exact S1 to S2 to S3 semantic identity and linkage.; direct in-census collaborators: `_validate_s1`, `_validate_amendment`, `_expected`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track1_source_constants.py` — **2 definition(s)**
Registered source-admission constants and refusal type.

- `SourceAdmissionError.__init__` (L84) — Initializes the enclosing exception or object fields; performs the source-defined update/validation
- `_refuse` (L89) — Constructs the typed refusal for the supplied value; returns the derived value to its caller

### `src/phase3/_modal_v05_track1_source_fields.py` — **9 definition(s)**
Shape, digest, candidate-closure, and field-value validation.

- `_nonempty_text` (L18) — Derives/validates the nonempty text value for the enclosing module contract; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_digest` (L33) — Derives the digest for the supplied value; direct in-census collaborators: `_nonempty_text`, `_refuse`; contains explicit exception/refusal paths
- `_optional_ref` (L43) — Checks optional ref; direct in-census collaborators: `_nonempty_text`; returns the derived value to its caller
- `_optional_digest` (L49) — Checks optional digest; direct in-census collaborators: `_digest`; returns the derived value to its caller
- `_candidate_value` (L55) — Derives/validates the candidate value value for the enclosing module contract; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_validate_evidence_ids` (L71) — Validates evidence IDs; direct in-census collaborators: `_refuse`, `_nonempty_text`; contains explicit exception/refusal paths
- `_validate_shape` (L86) — Validates shape; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_validated_record` (L97) — Validates record; direct in-census collaborators: `_validate_shape`, `_nonempty_text`, `_refuse`, `_digest`; contains explicit exception/refusal paths
- `_candidate_closure` (L148) — Derives/validates the candidate closure value for the enclosing module contract; direct in-census collaborators: `_candidate_value`, `_digest`, `_nonempty_text`, `_refuse`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track1_source_states.py` — **6 definition(s)**
Permission, egress, and evidence-state admission decisions.

- `_validate_authorization_and_egress` (L18) — Validates authorization and egress; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_require_admission_evidence` (L40) — Validates admission evidence; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_require_absent` (L73) — Validates absent; direct in-census collaborators: `_refuse`; contains explicit exception/refusal paths
- `_permission_only_fields` (L80) — Extracts only fields; returns the derived value to its caller
- `_state_result` (L96) — Derives/validates the state result value for the enclosing module contract; returns the derived value to its caller
- `validate_source_admission` (L115) — Validate the complete 28-field record without retrieving source bytes.; direct in-census collaborators: `_refuse`, `_validated_record`, `_candidate_closure`, `_validate_authorization_and_egress`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track2_acdc_batch.py` — **22 definition(s)**
Deterministic fixed-batch construction for Modal v0.5 ACDC. The public adapter consumes a complete Route-B pair source and derives the ACDC batch only after validating the registered census and immutable pair and member identities. The returned batch is still the fixed 25-row, descriptive ``n=1`` discovery input from the v0.5 contract.

- `_GateError.__init__` (L89) — Initializes the enclosing exception or object fields; performs the source-defined update/validation
- `_require` (L95) — Validates the supplied value; contains explicit exception/refusal paths
- `_safe_text` (L100) — Checks text; returns the derived value to its caller
- `_sequence` (L106) — Validates the supplied value; returns the derived value to its caller
- `_same_sequence` (L110) — Checks sequence; direct in-census collaborators: `_sequence`; returns the derived value to its caller
- `_manifest_identity` (L114) — Derives/validates the manifest identity value for the enclosing module contract; direct in-census collaborators: `_require`, `_safe_text`; returns the derived value to its caller
- `_validate_metadata` (L131) — Validates metadata; direct in-census collaborators: `_require`, `_same_sequence`; performs the source-defined update/validation
- `_raw_pairs` (L159) — Extracts pairs; direct in-census collaborators: `_require`, `_sequence`; returns the derived value to its caller
- `_context_error` (L173) — Validates error; returns the derived value to its caller
- `_check_member` (L180) — Validates member; direct in-census collaborators: `_require`; performs the source-defined update/validation
- `_construct_members` (L192) — Builds members; direct in-census collaborators: `instantiate_pair_members`; contains explicit exception/refusal paths
- `_checked_members` (L201) — Validates members; direct in-census collaborators: `_require`, `_construct_members`, `_check_member`; returns the derived value to its caller
- `_checked_key` (L211) — Validates key; direct in-census collaborators: `canonical_pair_key`; contains explicit exception/refusal paths
- `_projection` (L219) — Builds the supplied value; direct in-census collaborators: `canonical_bytes`; returns the derived value to its caller
- `_check_pair` (L230) — Validates pair; direct in-census collaborators: `_require`, `_context_error`, `_checked_key`, `_safe_text`; returns the derived value to its caller
- `_census` (L266) — Validates the supplied value; direct in-census collaborators: `_require`, `_check_pair`; returns the derived value to its caller
- `_representatives` (L295) — Selects the supplied value; direct in-census collaborators: `_require`, `_sequence`, `_check_pair`; returns the derived value to its caller
- `_prompt_key` (L323) — Validates key; direct in-census collaborators: `_require`; returns the derived value to its caller
- `_prompt_closure` (L337) — Validates closure; direct in-census collaborators: `_require`, `_sequence`, `_context_error`, `_prompt_key`; performs the source-defined update/validation
- `_public_member` (L359) — Projects the member fields exposed to the ACDC row; returns the derived value to its caller
- `_acdc_rows` (L365) — Derives/validates the ACDC rows; direct in-census collaborators: `_require`, `_public_member`; returns the derived value to its caller
- `build_acdc_v05_batch` (L389) — Build the shared, outcome-independent 25-row alternating ACDC batch.; direct in-census collaborators: `not_evaluable`, `_manifest_identity`, `_validate_metadata`, `_raw_pairs`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_acdc_common.py` — **34 definition(s)**
Shared identity and pair-member primitives for the fixed ACDC adapter.

- `BatchIdContractError.__init__` (L122) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `identity` (L127) — Derives identity for the supplied value; returns the derived value to its caller
- `not_evaluable` (L145) — Builds the non-evaluable result; direct in-census collaborators: `identity`; returns the derived value to its caller
- `first` (L181) — Extracts the first matching named field; returns the derived value to its caller
- `pair_key` (L188) — Derives/validates the pair key value for the enclosing module contract; direct in-census collaborators: `first`; returns the derived value to its caller
- `draw_id` (L193) — Derives/validates the draw ID value for the enclosing module contract; returns the derived value to its caller
- `block_id` (L204) — Extracts ID; direct in-census collaborators: `first`; returns the derived value to its caller
- `member_from_mapping` (L211) — Builds/extracts from mapping; returns the derived value to its caller
- `member_from_sequence` (L217) — Builds/extracts from sequence; returns the derived value to its caller
- `member_candidate` (L226) — Builds/extracts candidate; direct in-census collaborators: `member_from_mapping`, `member_from_sequence`, `first`; returns the derived value to its caller
- `member_prompt` (L239) — Builds/extracts prompt; direct in-census collaborators: `first`; returns the derived value to its caller
- `member` (L250) — Builds/extracts the supplied value; direct in-census collaborators: `member_candidate`, `first`, `pair_key`, `member_prompt`; returns the derived value to its caller
- `canonical_bytes` (L263) — Derives canonical bytes; returns the derived value to its caller
- `_refuse` (L273) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_require` (L277) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_safe_text` (L282) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_require_exact` (L288) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_require_string_keys` (L299) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_validate_unsigned_fields` (L303) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_validate_identity` (L320) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_validate_role_counts` (L338) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_batch_row_values` (L356) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_validate_batch_row_position` (L374) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_validate_batch_row_values` (L403) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_canonical_batch_row_key` (L429) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_validate_batch_row_key` (L436) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_validate_batch_row_identity` (L451) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_normalize_batch_row` (L490) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_normalize_batch_rows` (L503) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_validated_unsigned_batch` (L513) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_preimage_bytes` (L552) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `acdc_batch_preimage` (L579) — Return the exact framed preimage for an unsigned fixed ACDC batch.
- `batch_id` (L587) — Derives/validates the batch ID value for the enclosing module contract; direct in-census collaborators: `canonical_bytes`; returns the derived value to its caller
- `validate_batch_id` (L593) — Recompute and validate the derived identity of a signed ACDC batch.

### `src/phase3/_modal_v05_track2_acdc_execution.py` — **6 definition(s)**
Injected discovery execution boundary with independent source-manifest admission.

- `_call_discovery` (L37) — Calls discovery; direct in-census collaborators: `values`; returns the derived value to its caller
- `_cell_identity` (L55) — Derives/validates the cell identity value for the enclosing module contract; direct in-census collaborators: `identity`; returns the derived value to its caller
- `_validate_cell_configuration` (L90) — Validates cell configuration; direct in-census collaborators: `_cell_identity`; returns the derived value to its caller
- `_resolve_discovery` (L113) — Resolves discovery; direct in-census collaborators: `first`, `_call_discovery`; returns the derived value to its caller
- `_admission_error` (L128) — Independently admits the source manifest and exact batch identity.; direct in-census collaborators: `build_acdc_v05_batch`; returns the derived value to its caller
- `run_acdc_v05_cell` (L143) — Run one injected discovery callable and retain exactly one cell record.; direct in-census collaborators: `not_evaluable`, `_admission_error`, `_validate_cell_configuration`, `_resolve_discovery`, `summarize_acdc_v05_cell`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_acdc_summary.py` — **3 definition(s)**
Descriptive fixed-batch discovery summary for Modal v0.5 ACDC.

- `_jaccard` (L19) — Derives/validates the jaccard value for the enclosing module contract; returns the derived value to its caller
- `_jaccard_value` (L30) — Derives/validates the jaccard value value for the enclosing module contract; direct in-census collaborators: `first`, `_jaccard`; returns the derived value to its caller
- `summarize_acdc_v05_cell` (L49) — Summarize one fixed-batch discovery as a descriptive ''n=1'' record.; direct in-census collaborators: `not_evaluable`, `_jaccard_value`, `identity`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_metric_aggregate.py` — **11 definition(s)**
Cell-level aggregation of already pair-atomic Modal v0.5 metrics.

- `_validated_metric_values` (L28) — Validates metric values; direct in-census collaborators: `text`, `has_unvalidated_inference`, `finite_scalar`; returns the derived value to its caller
- `_metric_aggregate_result` (L56) — Builds/validates the metric aggregate result; returns the derived value to its caller
- `aggregate_metric_row` (L90) — Aggregate unique pair effects while preserving the complete cell join.; direct in-census collaborators: `rows`, `common_identity`, `refusal`, `_validated_metric_values`; returns the derived value to its caller
- `_contract_refusal` (L110) — Derives/validates the contract refusal value for the enclosing module contract; direct in-census collaborators: `refusal`; returns the derived value to its caller
- `_require_hash` (L122) — Validates hash; contains explicit exception/refusal paths
- `_require_token` (L128) — Validates token; contains explicit exception/refusal paths
- `_require_ref` (L134) — Validates ref; direct in-census collaborators: `_require_token`; contains explicit exception/refusal paths
- `_require_uint` (L141) — Validates uint; contains explicit exception/refusal paths
- `_canonical_record_hash` (L147) — Derives canonical record hash; direct in-census collaborators: `record_hash`; contains explicit exception/refusal paths
- `_validate_record_schema` (L162) — Validates record schema; direct in-census collaborators: `_validate_schema_value`; contains explicit exception/refusal paths
- `_validate_schema_value` (L190) — Validates schema value; direct in-census collaborators: `_require_hash`, `_require_token`, `_require_ref`, `_require_uint`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track2_metric_behavior.py` — **11 definition(s)**
Pair/member behavior-effect reductions for Modal v0.5.

- `_member_effect` (L22) — Builds/extracts effect; direct in-census collaborators: `first`, `finite_scalar`; returns the derived value to its caller
- `compute_behavior_member_effect` (L57) — Compute one member's binary behavior effect ''1[LD_Q>0]-1[LD_FP16>0]''.; direct in-census collaborators: `rows`, `refusal`, `common_identity`, `_member_effect`; returns the derived value to its caller
- `_pair_member_ids` (L92) — Derives/validates the pair member IDs value for the enclosing module contract; returns the derived value to its caller
- `_pair_member_effects` (L102) — Derives/validates the pair member effects value for the enclosing module contract; direct in-census collaborators: `_member_effect`; returns the derived value to its caller
- `_behavior_pair_result` (L116) — Builds/validates the behavior pair result; returns the derived value to its caller
- `compute_behavior_pair_effect` (L158) — Average the two member behavior effects into one pair-atomic value.; direct in-census collaborators: `rows`, `refusal`, `common_identity`, `_pair_member_ids`; returns the derived value to its caller
- `_logit_difference_member_effect` (L178) — Return one member's registered ''LD_Q - LD_FP16'' effect.; direct in-census collaborators: `has_unvalidated_inference`, `first`, `finite_scalar`; returns the derived value to its caller
- `_behavior_ld_member_result` (L219) — Builds/validates the behavior ld member result; returns the derived value to its caller
- `compute_behavior_ld_member_effect` (L245) — Compute one member's registered logit-difference effect ''LD_Q - LD_FP16''.; direct in-census collaborators: `rows`, `refusal`, `common_identity`, `_logit_difference_member_effect`; returns the derived value to its caller
- `_behavior_ld_pair_result` (L260) — Builds/validates the behavior ld pair result; returns the derived value to its caller
- `compute_behavior_ld_pair_effect` (L296) — Average the two member ''LD_Q - LD_FP16'' effects into one pair value.; direct in-census collaborators: `rows`, `refusal`, `common_identity`, `_pair_member_ids`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_metric_common.py` — **10 definition(s)**
Shared identity, completeness, and finite-value checks for metric adapters.

- `refusal` (L35) — Builds a typed refusal result; returns the derived value to its caller
- `rows` (L61) — Normalizes row input into a sequence; returns the derived value to its caller
- `first` (L73) — Extracts the first matching named field; returns the derived value to its caller
- `text` (L80) — Validates the supplied value; direct in-census collaborators: `first`; returns the derived value to its caller
- `identity` (L85) — Derives identity for the supplied value; direct in-census collaborators: `text`; returns the derived value to its caller
- `complete` (L111) — Derives/validates the complete value for the enclosing module contract; returns the derived value to its caller
- `identity_mismatch` (L130) — Return the contract-specific refusal for one identity comparison.; returns the derived value to its caller
- `common_identity` (L154) — Builds identity; direct in-census collaborators: `complete`, `identity`, `identity_mismatch`; returns the derived value to its caller
- `finite_scalar` (L185) — Validates scalar; direct in-census collaborators: `first`; returns the derived value to its caller
- `has_unvalidated_inference` (L196) — Return whether a row tries to populate an unregistered inference field.; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_metric_dissociation.py` — **13 definition(s)**
Canonical dissociation-decision construction for Modal v0.5.

- `_endpoint_counts` (L90) — Validates counts; returns the derived value to its caller
- `_final_dissociation_decision` (L109) — Derives dissociation decision; direct in-census collaborators: `_endpoint_counts`; returns the derived value to its caller
- `_dissociation_evidence_hash` (L126) — Builds/validates the dissociation evidence hash; returns the derived value to its caller
- `_ordered_control_refs` (L144) — Orders control refs; direct in-census collaborators: `_require_ref`; contains explicit exception/refusal paths
- `_validate_dissociation_schema` (L156) — Validates dissociation schema; direct in-census collaborators: `_validate_schema_value`; contains explicit exception/refusal paths
- `_validate_dissociation_semantics` (L176) — Validates dissociation semantics; contains explicit exception/refusal paths
- `_validate_dissociation_carrier` (L205) — Validates dissociation carrier; direct in-census collaborators: `_validate_dissociation_schema`, `_validate_dissociation_semantics`; performs the source-defined update/validation
- `_validate_dissociation_identity` (L210) — Validates dissociation identity; contains explicit exception/refusal paths
- `_validate_dissociation_bindings` (L227) — Validates dissociation bindings; direct in-census collaborators: `_endpoint_summary`, `_validate_dissociation_identity`, `_final_dissociation_decision`, `_dissociation_evidence_hash`; contains explicit exception/refusal paths
- `_resolve_dissociation_identity` (L250) — Resolves dissociation identity; direct in-census collaborators: `_require_hash`, `_require_token`, `_require_ref`; returns the derived value to its caller
- `_dissociation_record` (L301) — Builds/validates the dissociation record; direct in-census collaborators: `_endpoint_counts`, `_final_dissociation_decision`, `_dissociation_evidence_hash`; returns the derived value to its caller
- `validate_dissociation_decision` (L345) — Validate the exact 24-field ''dissociation_decision_v1'' carrier.; direct in-census collaborators: `_validate_dissociation_carrier`, `_validate_dissociation_bindings`; performs the source-defined update/validation
- `build_dissociation_decision` (L356) — Build one fail-closed three-endpoint dissociation decision carrier.; direct in-census collaborators: `_endpoint_summary`, `_resolve_dissociation_identity`, `_ordered_control_refs`, `_dissociation_record`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track2_metric_dissociation_endpoints.py` — **9 definition(s)**
Endpoint normalization and identity checks for Modal v0.5 dissociation.

- `_endpoint_metric` (L36) — Validates metric; direct in-census collaborators: `text`; returns the derived value to its caller
- `_endpoint_ref` (L40) — Validates ref; direct in-census collaborators: `text`; returns the derived value to its caller
- `_endpoint_state` (L44) — Validates state; direct in-census collaborators: `text`; returns the derived value to its caller
- `_endpoint_identity_value` (L48) — Validates identity value; direct in-census collaborators: `text`; returns the derived value to its caller
- `_endpoint_identity_error` (L70) — Validates identity error; direct in-census collaborators: `_endpoint_identity_value`; returns the derived value to its caller
- `_effective_endpoint_completeness` (L77) — Computes endpoint completeness; direct in-census collaborators: `text`; returns the derived value to its caller
- `_endpoint_row_summary` (L104) — Validates row summary; direct in-census collaborators: `has_unvalidated_inference`, `_endpoint_metric`, `_endpoint_ref`, `_endpoint_state`; returns the derived value to its caller
- `_endpoint_identity_mismatch` (L141) — Validates identity mismatch; returns the derived value to its caller
- `_endpoint_summary` (L159) — Validates summary; direct in-census collaborators: `_endpoint_row_summary`, `_endpoint_identity_mismatch`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_metric_interaction.py` — **6 definition(s)**
Canonical interaction-contrast construction for Modal v0.5.

- `_validate_interaction_semantics` (L85) — Validates interaction semantics; direct in-census collaborators: `_canonical_record_hash`; contains explicit exception/refusal paths
- `validate_interaction_contrast` (L111) — Validate the exact 23-field ''interaction_contrast_v1'' carrier.; direct in-census collaborators: `_validate_record_schema`, `_validate_interaction_semantics`, `_validate_contrast_cell_identity`, `_cell_rows`; performs the source-defined update/validation
- `_resolve_interaction_identity` (L130) — Resolves interaction identity; direct in-census collaborators: `_require_hash`, `_require_token`, `_require_ref`; contains explicit exception/refusal paths
- `_interaction_record` (L189) — Builds/validates the interaction record; direct in-census collaborators: `_cell_ref`, `_canonical_record_hash`; returns the derived value to its caller
- `build_interaction_contrast` (L231) — Build and validate one canonical four-cell interaction contrast record.; direct in-census collaborators: `_cell_rows`, `_indexed_contrast_cells`, `_common_cell_identity`, `_resolve_interaction_identity`; contains explicit exception/refusal paths
- `compute_interaction_contrast` (L288) — Compute ''MET-INT-DID'' and retain its exact canonical carrier.; direct in-census collaborators: `_cell_rows`, `build_interaction_contrast`, `validate_interaction_contrast`, `_interaction_effect`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_metric_interaction_cells.py` — **21 definition(s)**
Cell normalization and validation for Modal v0.5 interaction contrasts.

- `_cell_rows` (L19) — Derives/validates the cell rows value for the enclosing module contract; direct in-census collaborators: `_mapping_cell_rows`; returns the derived value to its caller
- `_mapping_cell_rows` (L28) — Normalizes cell rows; direct in-census collaborators: `values`; returns the derived value to its caller
- `_cell_method` (L42) — Derives/validates the cell method value for the enclosing module contract; direct in-census collaborators: `text`; returns the derived value to its caller
- `_cell_bits` (L46) — Derives/validates the cell bits value for the enclosing module contract; returns the derived value to its caller
- `_cell_ref` (L53) — Derives/validates the cell ref value for the enclosing module contract; direct in-census collaborators: `text`; returns the derived value to its caller
- `_cell_identity_value` (L57) — Derives/validates the cell identity value value for the enclosing module contract; direct in-census collaborators: `text`; returns the derived value to its caller
- `_cell_contract_ref` (L79) — Derives/validates the cell contract ref value for the enclosing module contract; direct in-census collaborators: `text`; returns the derived value to its caller
- `_cell_status_error` (L83) — Derives/validates the cell status error value for the enclosing module contract; direct in-census collaborators: `first`; returns the derived value to its caller
- `_cell_completeness_error` (L94) — Derives/validates the cell completeness error value for the enclosing module contract; direct in-census collaborators: `_cell_status_error`; returns the derived value to its caller
- `_cell_settlement_error` (L111) — Derives/validates the cell settlement error value for the enclosing module contract; direct in-census collaborators: `has_unvalidated_inference`, `_cell_status_error`, `_cell_completeness_error`; returns the derived value to its caller
- `_cell_reference_error` (L133) — Derives/validates the cell reference error value for the enclosing module contract; direct in-census collaborators: `_cell_ref`, `_cell_identity_value`, `_cell_contract_ref`, `_cell_settlement_error`; returns the derived value to its caller
- `_index_contrast_cell` (L147) — Indexes contrast cell; direct in-census collaborators: `_cell_method`, `_cell_bits`, `_cell_reference_error`; returns the derived value to its caller
- `_indexed_contrast_cells` (L164) — Indexes contrast cells; direct in-census collaborators: `_index_contrast_cell`; returns the derived value to its caller
- `_common_cell_identity` (L186) — Builds cell identity; direct in-census collaborators: `_cell_identity_value`; returns the derived value to its caller
- `_cell_effect` (L215) — Derives/validates the cell effect value for the enclosing module contract; direct in-census collaborators: `has_unvalidated_inference`, `first`, `finite_scalar`; returns the derived value to its caller
- `_validate_contrast_endpoint_family` (L236) — Validates contrast endpoint family; direct in-census collaborators: `text`; contains explicit exception/refusal paths
- `_validate_contrast_cell_identity` (L253) — Validates contrast cell identity; direct in-census collaborators: `_indexed_contrast_cells`, `_common_cell_identity`, `_validate_contrast_record_identity`, `_validate_contrast_endpoint_family`; contains explicit exception/refusal paths
- `_validate_contrast_record_identity` (L270) — Validates contrast record identity; contains explicit exception/refusal paths
- `_validate_contrast_condition_order` (L286) — Validates contrast condition order; contains explicit exception/refusal paths
- `_validate_contrast_cell_refs` (L295) — Validates contrast cell refs; direct in-census collaborators: `_cell_ref`; contains explicit exception/refusal paths
- `_interaction_effect` (L309) — Builds/validates the interaction effect; direct in-census collaborators: `_indexed_contrast_cells`, `_cell_effect`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track2_metric_patch.py` — **4 definition(s)**
Pair-level circuit-patch reductions for Modal v0.5.

- `_normalized_patch_values` (L19) — Normalizes patch values; direct in-census collaborators: `finite_scalar`; returns the derived value to its caller
- `_direct_patch_values` (L40) — Extracts patch values; direct in-census collaborators: `finite_scalar`; returns the derived value to its caller
- `_patch_values` (L59) — Normalizes values; direct in-census collaborators: `first`, `_normalized_patch_values`, `_direct_patch_values`; returns the derived value to its caller
- `compute_patch_pair_effect` (L66) — Compute one pair-level normalized patch recovery difference ''R_Q-R_FP16''.; direct in-census collaborators: `rows`, `refusal`, `common_identity`, `_patch_values`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_metric_residual.py` — **9 definition(s)**
Residual-vector similarity reductions for Modal v0.5.

- `_expand_node_rows` (L26) — Derives/validates the expand node rows value for the enclosing module contract; returns the derived value to its caller
- `_pooled_array` (L56) — Builds array; direct in-census collaborators: `first`; returns the derived value to its caller
- `_vector` (L86) — Normalizes the supplied value; direct in-census collaborators: `first`, `_pooled_array`; returns the derived value to its caller
- `_cosine` (L98) — Derives/validates the cosine value for the enclosing module contract; returns the derived value to its caller
- `_residual_member_value` (L109) — Computes member value; direct in-census collaborators: `text`, `_vector`, `_cosine`; returns the derived value to its caller
- `_pair_role_error` (L136) — Derives/validates the pair role error value for the enclosing module contract; direct in-census collaborators: `text`; returns the derived value to its caller
- `compute_residual_pair_effect` (L146) — Take the minimum of 37 node cosines per member, then average the pair.; direct in-census collaborators: `_expand_node_rows`, `rows`, `refusal`, `common_identity`; returns the derived value to its caller
- `_residual_magnitude_member_value` (L196) — Return the maximum 37-node relative norm deviation for one member.; direct in-census collaborators: `text`, `_vector`; returns the derived value to its caller
- `compute_residual_magnitude_pair_effect` (L233) — Aggregate ''abs(norm_Q / norm_FP16 - 1)'' over exactly 37 nodes per member.; direct in-census collaborators: `_expand_node_rows`, `rows`, `refusal`, `common_identity`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_model_contract.py` — **5 definition(s)**
Small model-identity primitives for the Modal v0.5 adapter.

- `ModalV05Refusal.__init__` (L17) — Initializes the enclosing exception or object fields; performs the source-defined update/validation
- `required_text` (L22) — Extracts/validates text; contains explicit exception/refusal paths
- `required_sha256` (L30) — Extracts/validates SHA-256; direct in-census collaborators: `required_text`; contains explicit exception/refusal paths
- `canonical_json` (L37) — Derives canonical JSON; contains explicit exception/refusal paths
- `identity_digest` (L46) — Derives identity for digest; direct in-census collaborators: `canonical_json`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_model_loader.py` — **3 definition(s)**
Injected checkpoint-loader boundary for Modal v0.5.

- `register_checkpoint_loader` (L13) — Install an explicitly injected loader for the current process.; contains explicit exception/refusal paths
- `clear_checkpoint_loader` (L22) — Remove the process-local injected loader.; performs the source-defined update/validation
- `load_frozen_checkpoint` (L29) — Load a frozen checkpoint only through an explicitly injected loader.; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track2_model_reference.py` — **1 definition(s)**
Same-block fp16 reference identity construction for Modal v0.5.

- `build_fp16_reference` (L16) — Create a same-block fp16 reference identity record without model I/O.; direct in-census collaborators: `required_text`, `required_sha256`, `identity_digest`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track2_quantizer_calibration.py` — **2 definition(s)**
Calibration/evaluation identity validation for the frozen quantizer grid.

- `values` (L10) — Normalizes the supplied values; contains explicit exception/refusal paths
- `validate_calibration` (L23) — Validates calibration; direct in-census collaborators: `values`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track2_quantizer_contract.py` — **11 definition(s)**
Frozen grid and validation primitives for the Modal v0.5 quantizer.

- `ModalV05Refusal.__init__` (L15) — Initializes the enclosing exception or object fields; performs the source-defined update/validation
- `canonical_method` (L20) — Derives canonical method; contains explicit exception/refusal paths
- `validate_bits` (L29) — Validates bits; contains explicit exception/refusal paths
- `enumerate_grid` (L37) — Return the immutable fifteen-cell method/bit census in canonical order.; returns the derived value to its caller
- `cell_id` (L43) — Return the canonical human-readable identifier for one quantized cell.; direct in-census collaborators: `canonical_method`, `validate_bits`; returns the derived value to its caller
- `display_cell_label` (L55) — Return the separate human-facing label for one grid cell.
- `canonicalize_cell_id` (L63) — Resolve a canonical ID or an exact legacy display alias to machine form.
- `_is_display_label` (L84) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_split_machine_id` (L91) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_parse_machine_bits` (L112) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `parse_cell_id` (L124) — Parse and strictly validate a canonical machine cell ID.

### `src/phase3/_modal_v05_track2_quantizer_operator.py` — **5 definition(s)**
Injected operator dispatch and private-copy application for quantizers.

- `register_quantizer_operator` (L20) — Register an explicitly injected operator for synthetic/runtime callers.; direct in-census collaborators: `canonical_method`; contains explicit exception/refusal paths
- `clear_quantizer_operators` (L29) — Clear process-local injected operators.; performs the source-defined update/validation
- `_operator_for` (L35) — Derives/validates the operator for value for the enclosing module contract; contains explicit exception/refusal paths
- `_invoke` (L57) — Call common two/three-argument operator forms without masking errors.; direct in-census collaborators: `values`, `operator`; returns the derived value to its caller
- `apply_quantizer` (L85) — Apply one frozen-grid operator to a private model copy.; direct in-census collaborators: `canonical_method`, `validate_bits`, `validate_calibration`, `_operator_for`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track2_stats_aggregate.py` — **1 definition(s)**
Pair-level descriptive aggregation for Modal v0.5 statistics.

- `aggregate_pair_effects` (L13) — Aggregate one finite value per retained pair and expose pair/block counts.; direct in-census collaborators: `rows`, `validated`, `refusal`, `validate_strata_contract`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_stats_bca_math.py` — **7 definition(s)**
BCa transform and deterministic resampling mathematics for Modal v0.5.

- `_probability` (L17) — Derives/validates the probability value for the enclosing module contract; contains explicit exception/refusal paths
- `bca_forward_map` (L23) — Map a nominal tail probability through the registered BCa transform.; direct in-census collaborators: `_probability`; contains explicit exception/refusal paths
- `bca_inverse_map` (L43) — Return the registered inverse-tail mapping used for BCa diagnostics.; direct in-census collaborators: `_probability`; contains explicit exception/refusal paths
- `bootstrap_means` (L62) — Derives/validates the bootstrap means value for the enclosing module contract; returns the derived value to its caller
- `jackknife_means` (L79) — Derives/validates the jackknife means value for the enclosing module contract; returns the derived value to its caller
- `prepare_bca_samples` (L88) — Prepares BCa samples; direct in-census collaborators: `bootstrap_means`, `jackknife_means`; returns the derived value to its caller
- `bca_parameters` (L109) — Derives/validates the BCa parameters value for the enclosing module contract; direct in-census collaborators: `bca_forward_map`, `bca_inverse_map`; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_stats_bootstrap.py` — **8 definition(s)**
Bootstrap request orchestration and result construction for Modal v0.5.

- `_bca_refusal` (L24) — Derives/validates the BCa refusal value for the enclosing module contract; direct in-census collaborators: `refusal`; returns the derived value to its caller
- `_valid_analysis_seed` (L30) — Checks analysis seed; returns the derived value to its caller
- `_valid_replicate_count` (L34) — Checks replicate count; returns the derived value to its caller
- `_declared_seed_matches` (L38) — Resolves seed matches; returns the derived value to its caller
- `_ordinal_seeds_match` (L43) — Validates seeds match; returns the derived value to its caller
- `_validate_bootstrap_request` (L55) — Validates bootstrap request; direct in-census collaborators: `_valid_analysis_seed`, `_valid_replicate_count`, `_declared_seed_matches`, `_ordinal_seeds_match`; returns the derived value to its caller
- `_bca_result` (L69) — Derives/validates the BCa result value for the enclosing module contract; returns the derived value to its caller
- `stratified_pair_bootstrap_bca` (L136) — Compute the deterministic nominal descriptive pair/block BCa interval.; direct in-census collaborators: `rows`, `_validate_bootstrap_request`, `refusal`, `prepare_bootstrap_data`; asserts the expected fixture/result invariant

### `src/phase3/_modal_v05_track2_stats_census.py` — **5 definition(s)**
Registered-strata census validation for Modal v0.5 statistics.

- `_census_totals` (L13) — Internal helper for the source-defined contract.
- `_observed_stratum_counts` (L41) — Internal helper for the source-defined contract.
- `_stratum_counts_error` (L50) — Internal helper for the source-defined contract.
- `_census_error` (L73) — Internal helper for the source-defined contract.
- `validate_strata_contract` (L90) — Validate the exact registered strata, provenance, and retained census.; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_stats_identity.py` — **6 definition(s)**
Pair-row identity and value validation for Modal v0.5 statistics.

- `_identity_mismatch` (L17) — Internal helper for the source-defined contract.
- `_stratum` (L34) — Internal helper for the source-defined contract.
- `_pair_weight_error` (L55) — Internal helper for the source-defined contract.
- `_validated_values` (L64) — Internal helper for the source-defined contract.
- `_validated_row` (L83) — Internal helper for the source-defined contract.
- `validated` (L103) — Validates the supplied value; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_stats_labels.py` — **7 definition(s)**
Conservative descriptive interval labels for Modal v0.5 statistics.

- `_interval_bounds` (L28) — Extracts bounds; returns the derived value to its caller
- `_interval_metadata` (L57) — Extracts metadata; returns the derived value to its caller
- `_formal_interval_fields_present` (L66) — Checks interval fields present; returns the derived value to its caller
- `_label_two_sided` (L78) — Assigns two sided; returns the derived value to its caller
- `_label_one_sided` (L88) — Assigns one sided; returns the derived value to its caller
- `descriptive_interval_label` (L102) — Return only a conservative pre-certificate descriptive label.; direct in-census collaborators: `_interval_bounds`, `_formal_interval_fields_present`, `_interval_metadata`, `_label_two_sided`; returns the derived value to its caller
- `refuse_unvalidated_inference` (L124) — Strip no evidence: refuse any populated formal-inference request.; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_stats_metadata.py` — **0 definition(s)**
Compatibility facade for Modal v0.5 statistics metadata admission.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/_modal_v05_track2_stats_metadata_admission.py` — **6 definition(s)**
Metadata admission and signature validation for Modal v0.5 statistics.

- `_metadata_container` (L22) — Internal helper for the source-defined contract.
- `_metadata_provenance` (L40) — Internal helper for the source-defined contract.
- `_metadata_census` (L78) — Internal helper for the source-defined contract.
- `_metadata_signature` (L99) — Internal helper for the source-defined contract.
- `_row_metadata` (L119) — Internal helper for the source-defined contract.
- `_validated_metadata` (L131) — Internal helper for the source-defined contract.

### `src/phase3/_modal_v05_track2_stats_metadata_contract.py` — **6 definition(s)**
Canonical registered-strata metadata primitives.

- `_strict_uint` (L24) — Internal helper for the source-defined contract.
- `_normalise_registered_stratum` (L30) — Internal helper for the source-defined contract.
- `_normalise_registered_strata` (L66) — Internal helper for the source-defined contract.
- `_exact_sequence` (L80) — Internal helper for the source-defined contract.
- `_normalise_retained_counts` (L89) — Internal helper for the source-defined contract.
- `_metadata_counts` (L111) — Internal helper for the source-defined contract.

### `src/phase3/_modal_v05_track2_stats_records.py` — **9 definition(s)**
Primitive record validation for Modal v0.5 statistics.

- `ModalV05Refusal.__init__` (L33) — Initializes the enclosing exception or object fields; performs the source-defined update/validation
- `refusal` (L38) — Builds a typed refusal result; returns the derived value to its caller
- `rows` (L67) — Normalizes row input into a sequence; returns the derived value to its caller
- `first` (L78) — Extracts the first matching named field; returns the derived value to its caller
- `text` (L85) — Validates the supplied value; direct in-census collaborators: `first`; returns the derived value to its caller
- `scalar` (L90) — Validates the supplied value; direct in-census collaborators: `first`; returns the derived value to its caller
- `identity` (L101) — Derives identity for the supplied value; direct in-census collaborators: `text`; returns the derived value to its caller
- `complete` (L123) — Derives/validates the complete value for the enclosing module contract; returns the derived value to its caller
- `has_unvalidated_inference` (L152) — Return whether a statistics row populates a typed-null inference field.; returns the derived value to its caller

### `src/phase3/_modal_v05_track2_stats_validation.py` — **2 definition(s)**
Small public facade for canonical statistics validation and bootstrap preparation.

- `canonical_strata` (L14) — Return the registered strata only after strict metadata validation.; returns the derived value to its caller
- `prepare_bootstrap_data` (L26) — Prepares bootstrap data; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_artifact_contract.py` — **0 definition(s)**
Shared constants and error type for artifact settlement.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/_modal_v05_track3_artifact_copy.py` — **18 definition(s)**
Resumable, descriptor-anchored, no-overwrite payload copying for artifacts.

- `_require_anchored_primitives` (L30) — Requires descriptor-relative no-follow payload operations before mutation; contains explicit exception/refusal paths
- `_destination_name` (L45) — Derives and validates the final child name for an anchored directory operation; contains explicit exception/refusal paths
- `_destination_stat` (L53) — Inspects a destination child through a held directory descriptor without following symlinks; contains explicit exception/refusal paths
- `_open_destination_descriptor` (L68) — Opens a regular destination child beneath a held descriptor and checks identity stability; contains explicit exception/refusal paths
- `_read_destination_bytes` (L102) — Reads destination bytes through an anchored descriptor and detects replacement or truncation; contains explicit exception/refusal paths
- `_hash_destination_file` (L141) — Hashes an anchored destination payload and verifies named/opened descriptor stability; contains explicit exception/refusal paths
- `_unlink_destination_if_same_inode` (L179) — Removes only an anchored temporary entry that still aliases the target inode; contains explicit exception/refusal paths
- `_directory_lock` (L203) — Serializes one artifact-directory lifecycle and yields its held no-follow directory descriptor; contains explicit exception/refusal paths
- `_payload_matches` (L222) — Rechecks regular-file identity, byte count, and SHA-256 through a held directory descriptor; contains explicit exception/refusal paths
- `_existing_payload_status` (L247) — Checks an existing payload and removes only a same-inode partial; direct in-census collaborators: `_payload_matches`, `_unlink_destination_if_same_inode`; contains explicit exception/refusal paths
- `_publish_staged_payload` (L265) — Publishes a verified staged payload with descriptor-relative no-overwrite hard-link semantics; direct in-census collaborators: `_concurrent_payload_status`, `_unlink_destination_if_same_inode`; contains explicit exception/refusal paths
- `_partial_copy_state` (L329) — Derives and validates partial copy state and prefix beneath a held descriptor before resuming; direct in-census collaborators: `_destination_stat`, `_read_destination_bytes`, `_stat_signature`; contains explicit exception/refusal paths
- `_open_partial_for_append` (L385) — Opens or exclusively creates a resumable partial by basename beneath a held descriptor; contains explicit exception/refusal paths
- `_write_payload_suffix` (L426) — Writes and fsyncs the remaining payload suffix while retaining source and destination descriptor checks; performs the source-defined update/validation
- `_verify_staged_payload` (L466) — Verifies staged byte count and SHA-256 through the anchored destination boundary; direct in-census collaborators: `_payload_matches`; contains explicit exception/refusal paths
- `_concurrent_payload_status` (L485) — Checks a competing payload destination through the held descriptor without accepting identity drift; direct in-census collaborators: `_payload_matches`; contains explicit exception/refusal paths
- `_copy_resumable` (L503) — Resumes, verifies, and descriptor-relative no-overwrite-promotes one payload; direct in-census collaborators: `_directory_lock`, `_partial_copy_state`, `_write_payload_suffix`, `_verify_staged_payload`, `_publish_staged_payload`; returns the derived value to its caller
- `_terminal_result` (L545) — Builds the verified terminal result projection; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_artifact_identity.py` — **9 definition(s)**
Artifact identity and path-boundary helpers.

- `_lstat_directory_entry` (L20) — Inspects one directory entry without following symlinks; contains explicit exception/refusal paths
- `_create_directory_entry` (L31) — Refuses unsafe path-based directory creation and directs callers to descriptor-relative admission; contains explicit exception/refusal paths
- `_validate_directory_entry` (L38) — Requires a directory component to be a non-symlink directory; contains explicit exception/refusal paths
- `_ensure_directory_chain` (L45) — Validates existing artifact-directory components without mutation and fails closed for mutable creation requests; direct in-census collaborators: `_lstat_directory_entry`, `_create_directory_entry`, `_validate_directory_entry`; contains explicit exception/refusal paths
- `_safe_component` (L66) — Checks component; contains explicit exception/refusal paths
- `_validate_identity` (L74) — Validates identity; direct in-census collaborators: `_safe_component`; contains explicit exception/refusal paths
- `_artifact_directory` (L94) — Derives/validates the artifact directory and rejects symlinked path components; direct in-census collaborators: `_safe_component`, `_ensure_directory_chain`; contains explicit exception/refusal paths
- `_safe_component_path` (L107) — Checks component path; direct in-census collaborators: `_safe_component`; contains explicit exception/refusal paths
- `_identity_projection` (L118) — Derives identity for projection; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_artifact_inventory.py` — **20 definition(s)**
Artifact source enumeration and fingerprint helpers.

- `_require_nofollow` (L24) — Requires a usable O_NOFOLLOW capability before artifact hashing; contains explicit exception/refusal paths
- `_nofollow_flags` (L31) — Combines operation flags with no-follow protection; contains explicit exception/refusal paths
- `_directory_flags` (L35) — Builds no-follow directory-open flags; contains explicit exception/refusal paths
- `_absolute_path` (L42) — Normalizes a path for descriptor-relative traversal; contains explicit exception/refusal paths
- `_open_directory_chain` (L49) — Opens each source-directory component with no-follow semantics; contains explicit exception/refusal paths
- `_stat_entry` (L70) — Inspects a final source entry without following symlinks; contains explicit exception/refusal paths
- `_stat_signature` (L89) — Derives a stable device/inode/size/mtime signature for race checks; returns the derived value to its caller
- `_regular_entry_stat` (L93) — Requires a regular non-symlink source payload entry; contains explicit exception/refusal paths
- `_open_hash_descriptor` (L105) — Opens a source payload for hashing with no-follow and replacement checks; contains explicit exception/refusal paths
- `_stream_hash` (L133) — Streams bytes into a SHA-256 digest; returns the derived value to its caller
- `_assert_hash_stable` (L144) — Verifies that the named and opened source payload remained stable during hashing; contains explicit exception/refusal paths
- `_hash_file_with_size` (L164) — Hashes one regular source payload and returns its size and digest; contains explicit exception/refusal paths
- `_now_utc` (L188) — Returns the current UTC timestamp; returns the derived value to its caller
- `_hash_file` (L192) — Derives the SHA-256 hash for one source payload; direct in-census collaborators: `_hash_file_with_size`; returns the derived value to its caller
- `_single_source_file` (L196) — Validates and returns a single source payload; contains explicit exception/refusal paths
- `_source_child` (L202) — Validates one enumerated source child and rejects symlink/non-regular payloads; contains explicit exception/refusal paths
- `_directory_source_files` (L220) — Enumerates a directory source into a deterministic regular-file list; direct in-census collaborators: `_source_child`; contains explicit exception/refusal paths
- `_source_files` (L231) — Derives/validates the source files value for the enclosing module contract; direct in-census collaborators: `_stat_entry`, `_single_source_file`, `_directory_source_files`; contains explicit exception/refusal paths
- `_inventory` (L242) — Derives/validates the inventory value for the enclosing module contract; direct in-census collaborators: `_hash_file_with_size`; returns the derived value to its caller
- `aggregate_artifact_fingerprint` (L256) — Hashes the ordered path/size/file-hash inventory, including a final LF.; direct in-census collaborators: `_safe_component_path`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track3_artifact_io.py` — **37 definition(s)**
Receipt and payload verification plus descriptor-anchored JSON publication for artifact transfers.

- `_require_dir_fd` (L35) — Requires a supported directory-descriptor operation before artifact mutation; contains explicit exception/refusal paths
- `_require_follow_symlinks` (L44) — Requires a supported no-follow operation before artifact mutation; contains explicit exception/refusal paths
- `_require_anchored_primitives` (L53) — Requires the complete descriptor-relative no-follow capability set; contains explicit exception/refusal paths
- `_require_nofollow` (L60) — Requires a usable O_NOFOLLOW capability before artifact path operations; contains explicit exception/refusal paths
- `_nofollow_flags` (L67) — Combines operation flags with no-follow protection; contains explicit exception/refusal paths
- `_directory_flags` (L71) — Builds no-follow directory-open flags; contains explicit exception/refusal paths
- `_absolute_path` (L78) — Normalizes a path for descriptor-relative traversal; contains explicit exception/refusal paths
- `_open_directory_chain` (L85) — Opens and safely creates each destination-directory component with no-follow semantics; contains explicit exception/refusal paths
- `_ensure_directory` (L119) — Ensures a destination directory exists without accepting symlink components; contains explicit exception/refusal paths
- `_open_parent_directory` (L125) — Opens a final-entry parent directory with no-follow traversal; contains explicit exception/refusal paths
- `_stat_entry` (L132) — Inspects a final entry without following symlinks; contains explicit exception/refusal paths
- `_stat_regular_entry_at` (L150) — Inspects a regular non-symlink child beneath a held parent descriptor; contains explicit exception/refusal paths
- `_open_regular_descriptor_at` (L164) — Opens a regular final entry beneath a held parent descriptor and checks identity; contains explicit exception/refusal paths
- `_open_regular_descriptor` (L201) — Opens a regular final entry with no-follow and replacement checks; contains explicit exception/refusal paths
- `_read_open_descriptor` (L233) — Reads an opened regular entry and detects replacement or truncation during the read; contains explicit exception/refusal paths
- `_read_open_descriptor_at` (L247) — Reads a regular child beneath a held parent descriptor; contains explicit exception/refusal paths
- `_read_descriptor_bytes` (L260) — Reads descriptor bytes and verifies named/opened entry stability; contains explicit exception/refusal paths
- `_assert_no_symlink_components` (L294) — Rejects a symlink final entry or parent component; contains explicit exception/refusal paths
- `_regular_stat` (L318) — Inspects a regular non-symlink artifact entry; contains explicit exception/refusal paths
- `_stat_signature` (L328) — Derives a stable device/inode/size/mtime signature for race checks; returns the derived value to its caller
- `_read_regular_bytes` (L337) — Reads regular bytes through a no-follow descriptor and detects replacement during the read; contains explicit exception/refusal paths
- `_hash_regular_file` (L342) — Hashes a regular payload through a no-follow descriptor and detects replacement during hashing; contains explicit exception/refusal paths
- `_unlink_if_same_inode` (L376) — Removes only a temporary path that still aliases the published inode; contains explicit exception/refusal paths
- `_unlink_if_same_inode_at` (L407) — Removes only a same-inode temporary child beneath a held parent descriptor; contains explicit exception/refusal paths
- `_cleanup_temporary_at` (L431) — Cleans up only the staged regular inode recorded for one anchored publication; contains explicit exception/refusal paths
- `_existing_json_digest` (L456) — Accepts only byte-identical existing JSON and refuses overwrite drift; direct in-census collaborators: `_read_regular_bytes`, `_unlink_if_same_inode`; contains explicit exception/refusal paths
- `_existing_json_digest_at` (L469) — Checks an existing JSON child through a held descriptor and cleans only its staged inode; contains explicit exception/refusal paths
- `_publish_json_without_overwrite_at` (L490) — Publishes fsynced JSON with descriptor-relative no-overwrite hard-link semantics; direct in-census collaborators: `_existing_json_digest_at`, `_read_open_descriptor_at`, `_cleanup_temporary_at`; contains explicit exception/refusal paths
- `_publish_json_without_overwrite` (L556) — Publishes JSON while retaining the legacy path-based helper contract and anchoring its operations; direct in-census collaborators: `_publish_json_without_overwrite_at`; contains explicit exception/refusal paths
- `_atomic_json` (L587) — Stages, fsyncs, and descriptor-relative publishes canonical JSON without clobbering an existing path; direct in-census collaborators: `_existing_json_digest_at`, `_publish_json_without_overwrite_at`; contains explicit exception/refusal paths
- `_read_json` (L644) — Reads JSON through the public no-follow regular-file boundary; contains explicit exception/refusal paths
- `_assert_identity` (L659) — Validates required artifact identity; contains explicit exception/refusal paths
- `_payload_path` (L665) — Builds a root-contained payload path; direct in-census collaborators: `_safe_component_path`, `_assert_no_symlink_components`; contains explicit exception/refusal paths
- `_inventory_rows` (L676) — Derives and checks expected/actual inventory rows; direct in-census collaborators: `_safe_component_path`, `_payload_path`, `_payload_record`; contains explicit exception/refusal paths
- `_payload_record` (L690) — Hashes one expected payload path and returns its closed size/digest record; direct in-census collaborators: `_payload_path`, `_hash_regular_file`; contains explicit exception/refusal paths
- `_actual_payload_paths` (L696) — Enumerates actual payloads and rejects symlink/non-regular entries; contains explicit exception/refusal paths
- `_verify_payload` (L719) — Verifies payload inventory, per-file hashes, and aggregate fingerprint; direct in-census collaborators: `_inventory_rows`, `_payload_record`, `_actual_payload_paths`, `aggregate_artifact_fingerprint`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track3_artifact_transfer.py` — **14 definition(s)**
Terminal artifact settlement orchestration.

- `_entry_exists` (L46) — Detects regular entries and broken symlinks so terminal-path tampering is not skipped
- `_read_json_file` (L51) — Reads one regular JSON control file and retains its exact bytes; direct in-census collaborators: `_read_regular_bytes`; contains explicit exception/refusal paths
- `_reject_secret_fields` (L64) — Internal helper for the source-defined contract.
- `_receipt_inventory` (L77) — Validates a non-empty receipt inventory sequence; contains explicit exception/refusal paths
- `_assert_receipt_identity` (L88) — Validates required and projected identity fields in a receipt; direct in-census collaborators: `_assert_identity`, `_identity_projection`; contains explicit exception/refusal paths
- `_validate_receipt_metadata` (L97) — Validates schema, state, transfer, completion, and source-archive metadata; direct in-census collaborators: `_assert_receipt_identity`; contains explicit exception/refusal paths
- `_validate_receipt_inventory` (L123) — Validates receipt inventory, aggregate fingerprint, and total byte count; direct in-census collaborators: `_receipt_inventory`, `aggregate_artifact_fingerprint`; contains explicit exception/refusal paths
- `_validate_receipt` (L141) — Validates receipt bytes, metadata, inventory, and payload together; direct in-census collaborators: `_read_json_file`, `_validate_receipt_metadata`, `_validate_receipt_inventory`, `_verify_payload`; returns the derived value to its caller
- `_validate_terminal_marker` (L164) — Validates marker schema, state, receipt binding, aggregate, and written-last state; contains explicit exception/refusal paths
- `_verify_terminal_evidence` (L183) — Verifies the complete receipt/payload/terminal-marker closure; direct in-census collaborators: `_validate_receipt`, `_read_json_file`, `_validate_terminal_marker`; returns the derived value to its caller
- `stage_to_archive` (L214) — Stages a local source and recovers a receipt-before-marker interruption; direct in-census collaborators: `_validate_identity`, `_source_files`, `_inventory`, `_copy_resumable`, `_ensure_directory`, `_verify_terminal_evidence`; contains explicit exception/refusal paths
- `_verify_archive` (L312) — Verifies a local archive's terminal evidence before rehydration; direct in-census collaborators: `_verify_terminal_evidence`; contains explicit exception/refusal paths
- `rehydrate_from_archive` (L323) — Rehydrates only a verified archive and recovers a receipt-before-marker interruption; direct in-census collaborators: `_validate_identity`, `_verify_archive`, `_artifact_directory`, `_ensure_directory`, `_copy_resumable`, `_verify_terminal_evidence`; contains explicit exception/refusal paths
- `read_artifact_receipt` (L428) — Reads a receipt without treating it as terminal evidence.; direct in-census collaborators: `_read_json`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_claim_reconciliation.py` — **19 definition(s)**
Conservative claim reconciliation over validated join rows.

- `_row_id` (L58) — Builds/extracts ID; returns the derived value to its caller
- `_downgrade` (L62) — Derives/validates the downgrade value for the enclosing module contract; direct in-census collaborators: `_row_id`; returns the derived value to its caller
- `_reconciliation_input_result` (L66) — Derives/validates the reconciliation input result value for the enclosing module contract; returns the derived value to its caller
- `_invalid_join_rows` (L76) — Derives/validates the invalid join rows value for the enclosing module contract; direct in-census collaborators: `validate_attempt_output_join`, `_row_id`; returns the derived value to its caller
- `_global_reconciliation_refusal` (L91) — Derives/validates the global reconciliation refusal value for the enclosing module contract; direct in-census collaborators: `_duplicate_reasons`, `_result`, `_downgrade`, `_identity_reasons`; returns the derived value to its caller
- `_claim_downgrades` (L105) — Derives/validates the claim downgrades value for the enclosing module contract; direct in-census collaborators: `_claim_row_reasons`, `_row_id`; returns the derived value to its caller
- `_source_candidate` (L114) — Builds the candidate closure required for source-record admission; returns the derived value to its caller
- `_source_refusal_result` (L130) — Builds a fail-closed source-admission reconciliation result; direct in-census collaborators: `_result`, `_downgrade`; returns the derived value to its caller
- `_source_records_snapshot` (L143) — Validates and snapshots the explicit source-record map before dereference; contains explicit refusal paths
- `_source_record_failure` (L166) — Validates one source record against candidate and join closure; contains explicit refusal paths
- `_claim_source_refusal` (L211) — Resolves every row source reference through the admitted 28-field source map; returns the derived refusal result to its caller
- `reconcile_claims` (L238) — Reconciles exact rows, applies conservative downgrades, and requires explicit source-record closure before claim promotion; direct in-census collaborators: `_reconciliation_input_result`, `_invalid_join_rows`, `_global_reconciliation_refusal`, `_claim_downgrades`, `_claim_source_refusal`; returns the derived value to its caller
- `_duplicate_reasons` (L264) — Derives/validates the duplicate reasons value for the enclosing module contract; returns the derived value to its caller
- `_mixed_identity_reasons` (L273) — Derives/validates the mixed identity reasons value for the enclosing module contract; returns the derived value to its caller
- `_missing_registry_closure_reasons` (L289) — Derives/validates missing registry closure reasons for the executable join-provenance fields; returns the derived value to its caller
- `_registry_closure_reasons` (L297) — Derives/validates registry closure mismatch reasons for the executable join-provenance fields; returns the derived value to its caller
- `_identity_reasons` (L316) — Derives identity for reasons; returns the derived value to its caller
- `_claim_row_reasons` (L328) — Derives/validates the claim row reasons value for the enclosing module contract; returns the derived value to its caller
- `_result` (L347) — Derives/validates the result value for the enclosing module contract; direct in-census collaborators: `_row_id`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_join_contract.py` — **0 definition(s)**
Compatibility facade for the decomposed exact join contract.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/_modal_v05_track3_join_schema.py` — **1 definition(s)**
Schema constants and error type for the exact join carrier.

- `_fail` (L231) — Derives/validates the fail value for the enclosing module contract; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track3_join_semantics.py` — **11 definition(s)**
Semantic and settlement checks for attempt/output joins.

- `_validate_semantic_enums` (L62) — Validates the closed semantic enums for the selected join schema, including its finite terminal-reason vocabulary; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_attempt_semantics` (L88) — Validates attempt semantics; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_pooling_semantics` (L105) — Validates pooling semantics; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_telemetry_gap_reason_evidence` (L114) — Validates positive incomplete telemetry-gap evidence for telemetry terminal reasons; direct in-census collaborators: `_fail`; contains explicit exception/refusal paths
- `_validate_terminal_reason_evidence` (L124) — Validates provider-state and reason-specific evidence for terminal settlement; direct in-census collaborators: `_validate_telemetry_gap_reason_evidence`, `_fail`; contains explicit exception/refusal paths
- `_validate_cap_terminal_reason_evidence` (L142) — Validates v2 operational-cap terminal evidence through the registered cap-settlement registry; direct in-census collaborators: `validate_operational_cap_settlement_evidence`, `_fail`; contains explicit exception/refusal paths
- `_validate_settlement_reference_semantics` (L183) — Enforces schema-version isolation between cap-prefixed settlement references and cap terminal reasons; direct in-census collaborators: `_fail`; contains explicit exception/refusal paths
- `_validate_terminal_reason_semantics` (L202) — Validates finite terminal-reason/status/provider-state relations and requires schema-specific evidence; direct in-census collaborators: `_validate_settlement_reference_semantics`, `_fail`, `_validate_terminal_reason_evidence`, `_validate_cap_terminal_reason_evidence`; contains explicit exception/refusal paths
- `_validate_settlement_semantics` (L238) — Validates settlement semantics for the selected join schema; direct in-census collaborators: `_fail`, `_validate_terminal_reason_semantics`, `_validate_success_closure`; performs the source-defined update/validation
- `_validate_semantics` (L256) — Validates semantics for the selected join schema and optional cap-evidence registry; direct in-census collaborators: `_validate_semantic_enums`, `_validate_attempt_semantics`, `_validate_pooling_semantics`, `_validate_settlement_semantics`; performs the source-defined update/validation
- `_validate_success_closure` (L267) — Validates success closure; direct in-census collaborators: `_fail`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_join_validation.py` — **15 definition(s)**
Shape, hash, and field validation for the exact join carrier.

- `_hash` (L33) — Derives the hash for the supplied value; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_nonempty` (L38) — Derives/validates the nonempty value for the enclosing module contract; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_record_hash` (L43) — Computes the schema-specific derived hash over the first 85 join fields; direct in-census collaborators: `canonical_record_preimage`; contains explicit exception/refusal paths
- `_schema_spec` (L60) — Resolves and validates the explicit v1/v2 schema identity before field or hash dispatch; direct in-census collaborators: `_fail`; contains explicit exception/refusal paths
- `join_record_hash_v1` (L75) — Computes the historical v1 derived hash over fields 1 through 85; direct in-census collaborators: `_record_hash`; returns the derived value to its caller
- `join_record_hash_v2` (L80) — Computes the versioned v2 derived hash over fields 1 through 85; direct in-census collaborators: `_record_hash`; returns the derived value to its caller
- `join_record_hash` (L85) — Dispatches the derived hash to the row's explicit schema identity; direct in-census collaborators: `_schema_spec`, `_record_hash`; contains explicit exception/refusal paths
- `_validate_join_mapping` (L93) — Validates exact field membership and the canonical v2 field order; direct in-census collaborators: `_fail`; contains explicit exception/refusal paths
- `_validate_join_values` (L107) — Validates values against the selected schema's types and nullability; direct in-census collaborators: `_fail`, `_hash`, `_nonempty`; performs the source-defined update/validation
- Historical prior entry retained: `_validate_join_schema` (formerly L72) — Validates join schema; direct in-census collaborators: `_fail`; retained as historical map text because the v2 dispatcher superseded this function.
- `_validate_expected_bindings` (L126) — Validates expected Route-B provenance bindings; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_join_hash` (L141) — Validates selected-schema semantics and the exact derived record hash; direct in-census collaborators: `_validate_semantics`, `_record_hash`, `_fail`; performs the source-defined update/validation
- `_validate_attempt_output_join` (L153) — Validates all 86 fields, schema identity, identity joins, settlement, and claim rules; direct in-census collaborators: `_validate_join_mapping`, `_schema_spec`, `_validate_join_values`, `_validate_join_hash`; contains explicit exception/refusal paths
- `validate_attempt_output_join` (L183) — Dispatches validation to the row's explicit v1 or v2 schema identity; direct in-census collaborators: `_validate_attempt_output_join`; contains explicit exception/refusal paths
- `validate_attempt_output_join_v1` (L197) — Validates only the historical v1 join relation; direct in-census collaborators: `_validate_attempt_output_join`; contains explicit exception/refusal paths
- `validate_attempt_output_join_v2` (L210) — Validates only the versioned v2 join relation and cap evidence; direct in-census collaborators: `_validate_attempt_output_join`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track3_runner_acdc.py` — **19 definition(s)**
Reference-first descriptive ACDC boundary with closed evaluator output, complete Route-B join closure, and explicit post-boundary uncertainty.

- `_ACDCOutputRefusal.__init__` (L183) — Initializes the typed evaluator-output refusal with a reason code
- `_fixed_count_matches` (L188) — Checks whether a supplied count matches the fixed ACDC contract; returns the derived value to its caller
- `_require_fixed_count` (L194) — Refuses a supplied count that is not fixed by the ACDC contract; contains explicit exception/refusal paths
- `_valid_batch_id` (L211) — Validates the canonical batch identity before evaluator admission; contains explicit exception/refusal paths
- `_admit_source_manifest` (L220) — Validates the source manifest and runner-derived ACDC batch identity before cell binding; contains explicit exception/refusal paths
- `_source_batch_binding_error` (L241) — Validates runner-derived batch and complete candidate/source join bindings; contains explicit exception/refusal paths
- `_admit_source_batch` (L261) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_acdc_executor_payload` (L283) — Builds the closed direct-ACDC executor projection from validated cell and runner-owned bindings; returns the derived value to its caller
- `_require_exact_evaluator_field` (L304) — Requires an evaluator field to match the registered cell or fixed ACDC configuration; contains explicit exception/refusal paths
- `_validate_evaluator_metadata` (L319) — Validates evaluator metadata against the descriptive-only ACDC contract; contains explicit exception/refusal paths
- `_validate_descriptive_fields` (L376) — Validates the complete finite descriptive measurement allowlist and its declared ranges; contains explicit exception/refusal paths
- `_validate_evaluator_counts` (L402) — Validates optional evaluator count fields against fixed ACDC values; contains explicit exception/refusal paths
- `_validated_evaluator_fields` (L438) — Rejects inferential/unknown evaluator fields and preserves only the closed descriptive allowlist; contains explicit exception/refusal paths
- `_structured_result` (L466) — Constructs a typed ACDC result with canonical metadata, provider state, and non-claim controls; returns the derived value to its caller
- `_bounded_error_type` (L510) — Bounds injected exception identity to a non-sensitive error class; returns the derived value to its caller
- `_unknown_after_executor` (L515) — Constructs a provider-unknown ACDC result after executor-boundary entry; returns the derived value to its caller
- `_join_refusal` (L564) — Constructs a typed pre-executor join refusal with canonical identity and fixed ACDC metadata; returns the derived value to its caller
- `_run_acdc_executor` (L587) — Runs the injected ACDC executor and admits, refuses, or marks its post-boundary result; direct in-census collaborators: `_call_executor`, `_acdc_executor_payload`, `_unknown_after_executor`, `_validated_evaluator_fields`, `_structured_result`; contains explicit exception/refusal paths
- `run_acdc_descriptive` (L645) — Runs or describes the fixed ACDC ``n=1`` cell with complete join closure, closed output admission, and provider-unknown failure handling; direct in-census collaborators: `_token`, `_cell_id`, `_admit_source_batch`, `_expected_join_bindings`, `_join_refusal`, `_run_acdc_executor`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track3_runner_cli.py` — **1 definition(s)**
Provider-inert Route-B v0.5 runner contract. This runner constructs and validates the frozen common-grid work description. It does not import a model/provider adapter and does not execute anything when no explicit executor is injected. An injected test executor is treated as an untrusted boundary: returned rows must still pass the exact join validator.

- `main` (L26) — Print a provider-free census summary; a zero exit is not success evidence.; direct in-census collaborators: `run_route_b_manifest`, `run_route_b_census`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_runner_contract.py` — **16 definition(s)**
Shared Route-B runner constants and primitive validators.

- `_sha` (L87) — Derives the hash for the supplied value; returns the derived value to its caller
- `_token` (L91) — Validates the supplied value; contains explicit exception/refusal paths
- `_cell_id` (L102) — Derives/validates the cell ID value for the enclosing module contract; returns the derived value to its caller
- `_validate_cell_fields` (L109) — Rejects undeclared Route-B cell fields before executor admission; contains explicit exception/refusal paths
- `_registered_cells` (L117) — Validates cells; direct in-census collaborators: `_cell_id`; returns the derived value to its caller
- `_synthetic_population` (L132) — Builds the deterministic provider-free synthetic population; returns the derived value to its caller
- `_make_pairs` (L148) — Builds canonical synthetic pairs; direct in-census collaborators: `build_route_b_pair_manifest`; returns the derived value to its caller
- `_is_sequence` (L169) — Validates whether a value is a non-string sequence; returns the derived value to its caller
- `_pair_refusal` (L175) — Constructs a typed canonical pair refusal; returns the derived value to its caller
- `_validate_serialized_pair_fields` (L200) — Validates serialized pair fields and explicit counterparts; contains explicit exception/refusal paths
- `_canonical_pair_row` (L217) — Prepares one canonical pair row before global collapse; direct in-census collaborators: `_prepare_standard_row`, `_validate_serialized_pair_fields`; contains explicit exception/refusal paths
- `_collapse_prepared_pairs` (L226) — Collapses prepared pair rows globally while retaining audit rows; direct in-census collaborators: `collapse_pair_duplicates`, `_pair_refusal`; contains explicit exception/refusal paths
- `_validate_pairs` (L254) — Validates and globally collapses all supplied pair rows; direct in-census collaborators: `_canonical_pair_row`, `_collapse_prepared_pairs`; contains explicit exception/refusal paths
- `_validate_registered_pair_census` (L278) — Validates the ten-draw/four-block/15-row registered census; contains explicit exception/refusal paths
- `_validate_cell_identity` (L299) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_validate_cells` (L320) — Validates cells and exact method/bit identity; direct in-census collaborators: `_cell_id`, `_token`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track3_runner_execution.py` — **26 definition(s)**
Injected-executor Route-B cell and census boundaries, including the sealed direct-cell carrier and explicit post-boundary uncertainty.

- `_PreparedRouteBCell.__init__` (L52) — Initializes the immutable prepared-cell carrier from an exact construction seal
- `_PreparedRouteBCell.__setattr__` (L65) — Refuses mutation of the prepared-cell carrier after construction
- `_PreparedRouteBCell.__getitem__` (L68) — Reads a field from the prepared-cell mapping
- `_PreparedRouteBCell.__iter__` (L71) — Iterates the prepared-cell mapping keys
- `_PreparedRouteBCell.__len__` (L74) — Returns the prepared-cell mapping size
- `_seal_prepared_route_b_cell` (L78) — Seals one manifest-produced Route-B cell before executor admission
- `_direct_supplied_derived_fields` (L88) — Detects caller-supplied derived ACDC fields and permits only the sealed carrier's runner-owned batch identifier
- `_seal_prepared_route_b_cells` (L99) — Seals every manifest-produced Route-B cell before census execution
- `_call_executor` (L104) — Calls executor; direct in-census collaborators: `execute`, `executor`; contains explicit exception/refusal paths
- `_frozen_join_identity` (L116) — Builds/validates join identity; returns the derived value to its caller
- `_manifest_join_bindings` (L126) — Derives/validates the manifest join bindings value for the enclosing module contract; direct in-census collaborators: `_frozen_join_identity`, `_token`; contains explicit exception/refusal paths
- `_complete_join_bindings` (L140) — Requires a complete six-field join binding source; contains explicit exception/refusal paths
- `_validate_expected_join_bindings` (L152) — Validates frozen and cell join equality; direct in-census collaborators: `_frozen_join_identity`, `_token`; contains explicit exception/refusal paths
- `_expected_join_bindings` (L169) — Resolves complete expected join bindings; direct in-census collaborators: `_complete_join_bindings`, `_validate_expected_join_bindings`; contains explicit exception/refusal paths
- `_runner_owned_result` (L184) — Applies runner-owned status, claim, decision, refusal, and scientific-success controls to executor outcomes; returns the derived value to its caller
- `_refused_before_executor` (L210) — Builds the pre-executor refusal result with executor/provider-injected and boundary state; returns the derived value to its caller
- `_not_executed` (L233) — Builds the pre-executor `NOT_EXECUTED` result with an explicit unentered-boundary marker; returns the derived value to its caller
- `_post_executor_unknown` (L247) — Represents an entered-but-unsettled executor boundary without asserting provider invocation; returns the derived value to its caller
- `_census_status` (L287) — Reduces a complete Route-B cell-status census without using invocation booleans; returns the derived value to its caller
- `_cap_join_provider_invocation_mismatch` (L309) — Detects a v2 cap join whose provider invocation state is inconsistent with the settled cap evidence; returns the derived value to its caller
- `_attach_cap_settlement_result` (L319) — Projects runner-owned cap settlement evidence and controls into the result without exposing executor-owned fields; performs the source-defined update/validation
- `_settle_join_result` (L335) — Settles a validated canonical join or fails closed after the executor boundary; direct in-census collaborators: `validate_attempt_output_join`, `_cap_join_provider_invocation_mismatch`, `_attach_cap_settlement_result`; returns the derived value to its caller
- `_refused_after_executor` (L410) — Refuses malformed executor output without losing boundary uncertainty; returns the derived value to its caller
- `_run_bound_cell` (L433) — Runs the bound cell entrypoint and preserves executor-boundary uncertainty; direct in-census collaborators: `_call_executor`, `_post_executor_unknown`, `_settle_join_result`; returns the derived value to its caller
- `run_route_b_cell` (L501) — Runs one cell only through an explicitly injected executor boundary and refuses unsealed caller-derived fields.; direct in-census collaborators: `_token`, `_not_executed`, `_expected_join_bindings`, `_refused_before_executor`, `_cell_id`; contains explicit exception/refusal paths
- `run_route_b_census` (L572) — Evaluates every registered cell with explicit missing, partial, and provider-unknown visibility; direct in-census collaborators: `run_route_b_manifest`, `_manifest_join_bindings`, `_seal_prepared_route_b_cells`, `run_route_b_cell`, `_census_status`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_runner_manifest.py` — **10 definition(s)**
Route-B manifest construction and census validation.

- `_prepare_manifest_header` (L42) — Prepares manifest header and strictly types the fixture flag; direct in-census collaborators: `_token`; contains explicit exception/refusal paths
- `_validate_candidate_binding` (L68) — Validates the complete frozen candidate binding; contains explicit exception/refusal paths
- `_manifest_counts` (L83) — Derives/validates the manifest counts value for the enclosing module contract; contains explicit exception/refusal paths
- `_manifest_pairs` (L101) — Derives/validates the manifest pairs and collapse summary; direct in-census collaborators: `_make_pairs`, `_validate_pairs`, `_validate_registered_pair_census`; contains explicit exception/refusal paths
- `_manifest_cells` (L119) — Validates and materializes exact manifest bindings on every cell; direct in-census collaborators: `_registered_cells`, `_validate_cells`; contains explicit exception/refusal paths
- `_acdc_source_manifest` (L158) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_materialize_acdc_batch` (L219) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_bind_acdc_batch` (L237) — Derives/validates the live contract value; contains explicit exception/refusal paths
- `_manifest_payload` (L265) — Builds the manifest payload and pair-collapse metadata; returns the derived value to its caller
- `run_route_b_manifest` (L331) — Construct and validate a synthetic/provider-free Route-B work manifest.; direct in-census collaborators: `_prepare_manifest_header`, `_validate_candidate_binding`, `_manifest_counts`, `_manifest_pairs`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track3_safety_caps.py` — **20 definition(s)**
Operational cap evaluation helpers for Track-3 safety facade.

- `_nonnegative` (L96) — Validates the supplied value; contains explicit exception/refusal paths
- `_refusal` (L102) — Derives/validates the refusal value for the enclosing module contract; returns the derived value to its caller
- `_validate_cap_header` (L116) — Validates cap header; direct in-census collaborators: `_refusal`; returns the derived value to its caller
- `_read_cap_values` (L130) — Reads cap values; direct in-census collaborators: `_refusal`, `_nonnegative`; returns the derived value to its caller
- `_read_observed_values` (L154) — Reads observed values; direct in-census collaborators: `_refusal`, `_nonnegative`; returns the derived value to its caller
- `_crossed_caps` (L171) — Derives/validates the crossed caps value for the enclosing module contract; returns the derived value to its caller
- `_is_token` (L187) — Validates a printable non-empty operational-cap token; returns the derived value to its caller
- `_is_sha256` (L193) — Validates a lower-case SHA-256 evidence digest; returns the derived value to its caller
- `cap_settlement_evidence_hash` (L208) — Returns the deterministic hash for one typed cap-settlement record; contains explicit exception/refusal paths
- `_validate_cap_evidence_hash` (L246) — Validates the stored cap-settlement evidence hash against its canonical preimage; contains explicit exception/refusal paths
- `_validate_cap_evidence_values` (L259) — Validates exact non-negative cap and observed value maps; returns the parsed value or refusal code
- `_validate_cap_evidence_surface` (L275) — Validates the closed cap-settlement evidence field surface and settlement reference; returns a refusal code or null
- `_validate_cap_evidence_binding` (L294) — Validates candidate, scope, attempt, and packet identity bindings for cap evidence; returns a refusal code or null
- `_validate_cap_evidence_header` (L325) — Validates the cap schema version and frozen trigger precedence; returns a refusal code or null
- `_expected_crossed_caps` (L338) — Reconstructs the exact ordered cap crossings from cap and observed values; returns the derived value to its caller
- `_validate_cap_evidence_crossings` (L354) — Validates that recorded cap crossings exactly match the deterministic boundary evaluation; returns the derived value to its caller
- `_validate_cap_evidence_disposition` (L372) — Validates primary-stop reason, invocation phase, provider state, status, reason, and path relations; returns a refusal code or null
- `_validate_cap_evidence_controls` (L396) — Validates the fixed non-claim, no-retry, and no-relaunch controls; returns a refusal code or null
- `validate_operational_cap_settlement_evidence` (L414) — Validates one complete hash-bound operational-cap settlement receipt; direct in-census collaborators: `_validate_cap_evidence_surface`, `_validate_cap_evidence_binding`, `_validate_cap_evidence_header`, `_validate_cap_evidence_crossings`, `_validate_cap_evidence_disposition`, `_validate_cap_evidence_controls`; contains explicit exception/refusal paths
- `evaluate_cap_packet` (L464) — Evaluates all operational caps in the frozen precedence order. Missing or design-time-null cap values are refusals, never an implicit unlimited budget. A boundary observation equal to a cap triggers it. Multiple triggers are retained, while the first registered trigger is the primary reason.; direct in-census collaborators: `_refusal`, `_validate_cap_header`, `_read_cap_values`, `_read_observed_values`, `_crossed_caps`; asserts the expected fixture/result invariant

### `src/phase3/_modal_v05_track3_safety_settlement.py` — **32 definition(s)**
Fail-closed stop-loss settlement helpers.

- `_stop_loss_refusal` (L88) — Builds the fixed stop-loss refusal result; returns the derived value to its caller
- `_canonical_terminal_refusal` (L95) — Builds a fixed refusal for the explicit canonical terminal-disposition adapter surface; returns the derived value to its caller
- `_is_nonempty_ref` (L103) — Validates a non-empty reference token; returns the derived value to its caller
- `_is_nonnegative_int` (L107) — Validates a non-negative integer evidence value; returns the derived value to its caller
- `_attempt_namespace` (L111) — Builds the attempt namespace; contains explicit exception/refusal paths
- `_reason_code` (L123) — Resolves the finite stop-loss reason code; contains explicit exception/refusal paths
- `_provider_unknown` (L130) — Checks whether provider or receipt identity is unknown; direct in-census collaborators: `_reason_code`; returns the derived value to its caller
- `_known_failure` (L140) — Detects known failed attempt outcomes; returns the derived value to its caller
- `settle_stop_loss` (L149) — Returns a terminal non-claim stop-loss disposition while preserving the separate noncanonical API surface; direct in-census collaborators: `_refusal`, `_attempt_namespace`, `_reason_code`, `_provider_unknown`, `_known_failure`; returns the derived value to its caller
- `_cap_settlement_refusal` (L218) — Builds a typed operational-cap settlement refusal with fixed no-retry controls; returns the derived value to its caller
- `_cap_attempt_identity` (L226) — Validates candidate, scope, and attempt identity against the cap packet; direct in-census collaborators: `_attempt_namespace`, `_is_sha256`, `_is_token`; returns the derived value to its caller
- `_cap_packet_identity` (L245) — Validates cap packet schema, ID, action, and trigger precedence; direct in-census collaborators: `_is_token`; returns a refusal code or null
- `_unknown_cap_outcome` (L261) — Builds the same-key provider-unknown outcome for uncertain cap invocation or receipt state; returns the derived value to its caller
- `_build_cap_settlement_evidence` (L291) — Constructs the complete hash-bound v2 cap-settlement evidence record; direct in-census collaborators: `cap_settlement_evidence_hash`; returns the derived value to its caller
- `_cap_invocation_phase_error` (L331) — Internal helper for the source-defined contract.
- `_prepare_cap_settlement` (L352) — Validates cap settlement inputs, invocation phase, and identity before evaluation; direct in-census collaborators: `_cap_settlement_refusal`, `_cap_attempt_identity`, `_cap_packet_identity`; contains explicit exception/refusal paths
- `_clear_cap_settlement` (L374) — Builds a non-crossing operational-cap clear result with retained identity and non-claim controls; returns the derived value to its caller
- `_before_invocation_cap_refusal` (L392) — Builds the typed pre-invocation cap refusal without a canonical join; direct in-census collaborators: `_cap_settlement_refusal`; returns the derived value to its caller
- `_register_cap_evidence` (L411) — Registers cap evidence idempotently and refuses registry collisions or invalid registries; returns a refusal code or null
- `_settle_known_cap` (L431) — Settles a known post-invocation cap crossing into registered typed evidence or a bounded unknown result; direct in-census collaborators: `_provider_unknown`, `_unknown_cap_outcome`, `_before_invocation_cap_refusal`, `_build_cap_settlement_evidence`, `_register_cap_evidence`; returns the derived value to its caller
- `settle_operational_cap` (L501) — Evaluates and settles one known operational-cap crossing with explicit before/after/unknown boundaries; direct in-census collaborators: `_prepare_cap_settlement`, `evaluate_cap_packet`, `_clear_cap_settlement`, `_before_invocation_cap_refusal`, `_settle_known_cap`; contains explicit exception/refusal paths
- `_cap_evidence_from_settlement` (L546) — Extracts and validates the typed cap-evidence payload from a settlement result; direct in-census collaborators: `validate_operational_cap_settlement_evidence`; returns the derived value to its caller
- `_validate_cap_settlement_projection` (L593) — Validates the exact noncanonical cap-settlement projection before canonical adaptation; direct in-census collaborators: `_cap_evidence_from_settlement`; returns a refusal code or null
- `adapt_operational_cap_to_canonical_terminal` (L640) — Returns a v2 terminal projection after registry-backed cap validation; direct in-census collaborators: `_validate_cap_settlement_projection`; returns the derived value to its caller
- `_validate_stop_loss_controls` (L700) — Validates non-claim, retry, and relaunch controls at the adapter boundary; returns a refusal code or null
- `_validate_stop_loss_terminal_flags` (L712) — Validates terminal/reconciliation flags for known and orphan stop-loss paths; returns a refusal code or null
- `_validate_stop_loss_boundary` (L729) — Validates stop-loss path, action, status, controls, and terminal flags before adaptation; direct in-census collaborators: `_validate_stop_loss_controls`, `_validate_stop_loss_terminal_flags`; returns a refusal code or null
- `_validate_adapter_telemetry_evidence` (L749) — Validates positive incomplete telemetry evidence for adapter translation; returns a refusal code or null
- `_validate_adapter_orphan_evidence` (L760) — Validates same-key orphan reconciliation and settlement evidence; direct in-census collaborators: `_is_nonempty_ref`; returns a refusal code or null
- `_validate_adapter_evidence` (L776) — Validates provider-state and reason-specific evidence for canonical terminal translation; direct in-census collaborators: `_validate_adapter_telemetry_evidence`, `_validate_adapter_orphan_evidence`, `_is_nonempty_ref`, `_is_nonnegative_int`; returns a refusal code or null
- `_build_canonical_terminal_disposition` (L796) — Builds the explicit noncanonical adapter projection for the unchanged canonical 86-field assembly; returns the derived value to its caller
- `adapt_stop_loss_to_canonical_terminal` (L833) — Translates supported stop-loss results into a typed canonical-terminal projection while refusing unsupported or incomplete boundaries; direct in-census collaborators: `_canonical_terminal_refusal`, `_validate_stop_loss_boundary`, `_validate_adapter_evidence`, `_build_canonical_terminal_disposition`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_state_append.py` — **0 definition(s)**
Compatibility facade for decomposed state append operations.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/_modal_v05_track3_state_append_transaction.py` — **4 definition(s)**
Append transaction and transition checks for state namespaces.

- `_validate_transition_for_append` (L30) — Validates transition for append; direct in-census collaborators: `_validate_first_event`, `_validate_current_edge`, `_ref_id`; contains explicit exception/refusal paths
- `_finalize_appended_event` (L46) — Derives/validates the finalize appended event value for the enclosing module contract; direct in-census collaborators: `_validate_shape`, `state_event_hash`, `_validate_child_refs`; performs the source-defined update/validation
- `_append_result` (L54) — Appends result; returns the derived value to its caller
- `append_state_event` (L74) — Append one event to an in-memory namespace head using a strict CAS. The input mappings are never mutated. ''head'' may carry an optional ''common_predecessor'' mapping for the one legal COMMON→ROUTE_B branch activation. All other cross-namespace relationships must be represented by typed evidence IDs and are not inferred here.; direct in-census collaborators: `_head_snapshot`, `_validate_head_snapshot`, `_prepare_event`, `_validate_prepared_cas`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track3_state_cas.py` — **14 definition(s)**
Head snapshot and event-preparation helpers for state CAS.

- `empty_head` (L18) — Return a versioned empty namespace head suitable for a pure append.; returns the derived value to its caller
- `_event_defaults` (L41) — Builds/validates defaults; returns the derived value to its caller
- `_head_snapshot` (L63) — Snapshots snapshot; returns the derived value to its caller
- `_validate_head_shape` (L73) — Internal helper for the source-defined contract.
- `_validate_head_metadata` (L88) — Internal helper for the source-defined contract.
- `_validate_sentinel_head` (L95) — Internal helper for the source-defined contract.
- `_validate_committed_history` (L104) — Internal helper for the source-defined contract.
- `_validate_head_projection` (L123) — Internal helper for the source-defined contract.
- `_validate_head_snapshot` (L133) — Validates head snapshot; direct in-census collaborators: `_is_hash`; contains explicit exception/refusal paths
- `_prepare_event` (L153) — Prepares event; direct in-census collaborators: `_event_defaults`, `_head_field`; returns the derived value to its caller
- `_validate_prepared_cas` (L172) — Validates prepared CAS; contains explicit exception/refusal paths
- `_validate_head_scope` (L186) — Validates head scope; contains explicit exception/refusal paths
- `_validate_event_identities` (L196) — Validates event identities; contains explicit exception/refusal paths
- `_head_field` (L207) — Snapshots field; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_state_children.py` — **8 definition(s)**
Prior-event child-reference and cycle checks.

- `_prior_by_id` (L12) — Internal helper for the source-defined contract.
- `_validate_current_refs` (L19) — Internal helper for the source-defined contract.
- `_validate_edge_identity` (L34) — Internal helper for the source-defined contract.
- `_child_graph` (L54) — Internal helper for the source-defined contract.
- `_visit_child_graph` (L67) — Internal helper for the source-defined contract.
- `_validate_graph` (L84) — Internal helper for the source-defined contract.
- `_validate_committed_edges` (L97) — Internal helper for the source-defined contract.
- `_validate_child_refs` (L109) — Validates child refs; direct in-census collaborators: `_ref_id`, `_fail`; performs the source-defined update/validation

### `src/phase3/_modal_v05_track3_state_codec.py` — **0 definition(s)**
Publicly shared codec facade for state identity helpers.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/_modal_v05_track3_state_collection_codec.py` — **4 definition(s)**
Ordered-list, map, and nullable value encoding.

- `_list_item` (L11) — Encodes item; direct in-census collaborators: `_fail`, `_validate_scalar`; returns the derived value to its caller
- `_encode_list` (L34) — Encodes list; direct in-census collaborators: `_fail`, `_list_item`; returns the derived value to its caller
- `_encode_map` (L49) — Encodes map; direct in-census collaborators: `_fail`, `_list_item`; returns the derived value to its caller
- `_encode_value` (L71) — Encodes value; direct in-census collaborators: `_fail`, `_encode_list`, `_encode_map`, `_validate_scalar`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_state_contract.py` — **6 definition(s)**
Shared schema, tokens, and state-event identity helpers.

- `_fail` (L350) — Derives/validates the fail value for the enclosing module contract; contains explicit exception/refusal paths
- `_is_hash` (L354) — Checks whether hash; returns the derived value to its caller
- `_is_ascii_token` (L358) — Checks whether ascii token; returns the derived value to its caller
- `_state_prefix` (L362) — Derives/validates the state prefix value for the enclosing module contract; returns the derived value to its caller
- `_ref_id` (L368) — Resolves ID; returns the derived value to its caller
- `_transition_class` (L376) — Validates class; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_state_controls.py` — **5 definition(s)**
Review, blocked-state, and provider control validation.

- `_validate_review_fields` (L18) — Validates review fields; direct in-census collaborators: `_fail`, `_transition_class`; performs the source-defined update/validation
- `_validate_blocked_entry` (L33) — Validates blocked entry; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_blocked_reentry` (L53) — Validates blocked reentry; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_blocked_fields` (L68) — Validates blocked fields; direct in-census collaborators: `_validate_blocked_entry`, `_validate_blocked_reentry`, `_fail`; returns the derived value to its caller
- `_validate_provider_fields` (L86) — Validates provider fields; direct in-census collaborators: `_is_ascii_token`, `_fail`; performs the source-defined update/validation

### `src/phase3/_modal_v05_track3_state_record_codec.py` — **4 definition(s)**
Canonical record preimages and state-event hashes.

- `canonical_record_preimage` (L16) — Encode a record using the plan's length-delimited, typed format.; direct in-census collaborators: `_is_ascii_token`, `_encode_value`; contains explicit exception/refusal paths
- `record_hash` (L56) — Return the lower-case SHA-256 of a canonical record preimage.; direct in-census collaborators: `canonical_record_preimage`; returns the derived value to its caller
- `state_event_preimage` (L69) — Return the exact 36-field ''state_event_v1'' hash preimage.; direct in-census collaborators: `canonical_record_preimage`; returns the derived value to its caller
- `state_event_hash` (L79) — Compute the derived event hash without mutating ''event''.; direct in-census collaborators: `state_event_preimage`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_state_scalar_codec.py` — **6 definition(s)**
Scalar encoding and validation for state-record identities.

- `_validate_text_scalar` (L15) — Validates text scalar; direct in-census collaborators: `_fail`, `_is_ascii_token`; returns the derived value to its caller
- `_validate_hash_scalar` (L28) — Validates hash scalar; direct in-census collaborators: `_is_hash`, `_fail`; returns the derived value to its caller
- `_validate_integer_scalar` (L34) — Validates integer scalar; direct in-census collaborators: `_fail`; returns the derived value to its caller
- `_validate_bool_scalar` (L44) — Validates bool scalar; direct in-census collaborators: `_fail`; returns the derived value to its caller
- `_validate_decimal_scalar` (L50) — Validates decimal scalar; direct in-census collaborators: `_fail`; returns the derived value to its caller
- `_validate_scalar` (L56) — Validates scalar; direct in-census collaborators: `_validate_text_scalar`, `_validate_hash_scalar`, `_validate_integer_scalar`, `_validate_bool_scalar`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_state_scope.py` — **4 definition(s)**
Namespace and artifact scope checks for state events.

- `_validate_route_scope` (L10) — Validates route scope; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_artifact_scope` (L26) — Validates artifact scope; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_event_references` (L42) — Validates event references; direct in-census collaborators: `_ref_id`, `_fail`; performs the source-defined update/validation
- `_validate_scoped_fields` (L51) — Validates scoped fields; direct in-census collaborators: `_validate_route_scope`, `_validate_artifact_scope`, `_validate_event_references`; performs the source-defined update/validation

### `src/phase3/_modal_v05_track3_state_shape.py` — **5 definition(s)**
State-event shape and canonical hash validation.

- `_validate_event_fields` (L29) — Validates event fields; direct in-census collaborators: `_fail`, `_is_hash`, `_encode_value`; performs the source-defined update/validation
- `_validate_event_header` (L43) — Validates event header; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_event_state_tokens` (L54) — Validates event state tokens; direct in-census collaborators: `_fail`, `_state_prefix`; performs the source-defined update/validation
- `_validate_shape` (L69) — Validates shape; direct in-census collaborators: `_validate_event_fields`, `_validate_event_header`, `_validate_event_state_tokens`, `_validate_scoped_fields`; performs the source-defined update/validation
- `validate_state_event` (L81) — Validate a complete state event and its derived hash.; direct in-census collaborators: `_validate_shape`, `_validate_current_edge`; contains explicit exception/refusal paths

### `src/phase3/_modal_v05_track3_state_transitions.py` — **7 definition(s)**
Finite state transition and branch-activation validation.

- `_validate_predecessor_hash` (L19) — Internal helper for the source-defined contract.
- `_validate_route_b_activation_shape` (L27) — Internal helper for the source-defined contract.
- `_validate_route_b_first_event` (L50) — Validates route b first event; direct in-census collaborators: `_fail`, `_ref_id`; performs the source-defined update/validation
- `_validate_namespace_activation` (L69) — Validates namespace activation; direct in-census collaborators: `_fail`; performs the source-defined update/validation
- `_validate_first_event` (L106) — Validates first event; direct in-census collaborators: `_fail`, `_validate_route_b_first_event`, `_validate_namespace_activation`; returns the derived value to its caller
- `_allowed_edge` (L135) — Checks edge; direct in-census collaborators: `_state_prefix`; returns the derived value to its caller
- `_validate_current_edge` (L153) — Validates current edge; direct in-census collaborators: `_fail`, `_allowed_edge`; returns the derived value to its caller

### `src/phase3/_modal_v05_track3_state_validation.py` — **0 definition(s)**
Compatibility facade for decomposed state-event validation.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_acdc.py` — **0 definition(s)**
Public facade for the fixed reference-first Modal v0.5 ACDC adapter.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_artifacts.py` — **0 definition(s)**
Local temporary-root artifact settlement and rehydration primitives. The public surface is kept stable while the implementation is split into responsibility-sized provider-free Track-3 helpers.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_contracts.py` — **0 definition(s)**
Public facade for the provider-free v0.5 semantic-chain contract.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_identity.py` — **0 definition(s)**
Public facade for exact provider-free v0.5 candidate identity checks.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_metrics.py` — **0 definition(s)**
Public facade for finite, pair-atomic Modal v0.5 metric adapters.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_models.py` — **0 definition(s)**
Public facade for provider-free Modal v0.5 model adapters.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_pair_contract.py` — **0 definition(s)**
Public facade for the provider-free v0.5 pair contracts.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_quantizers.py` — **0 definition(s)**
Public facade for the frozen Modal v0.5 quantizer/operator boundary.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_reconciliation.py` — **0 definition(s)**
Exact attempt/output joins and conservative claim reconciliation. The public surface is stable; the schema validator and reconciliation projection live in separate private Track-3 helpers. Claim promotion also requires an explicit map of canonical 28-field source/admission records keyed by each row's source egress reference.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_safety.py` — **0 definition(s)**
Fail-closed operational caps and stop-loss settlement for Modal v0.5. Implementation is split into private cap-evaluation and stop-loss-settlement helpers while preserving the public provider-inert API.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_sources.py` — **0 definition(s)**
Public facade for provider-free Route-B source admission checks.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_state.py` — **0 definition(s)**
Provider-free lifecycle state and CAS primitives for the Modal v0.5 plan. The public state-event API remains unchanged; schema encoding, event validation, and append-only CAS transactions live in separate private Track-3 helpers.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/modal_v05_statistics.py` — **0 definition(s)**
Public facade for descriptive pair/block Modal v0.5 statistics.

- No function definitions in the AST census; constants/contracts only.

### `src/phase3/run_modal_v05.py` — **0 definition(s)**
Provider-inert Route-B v0.5 runner contract. The public runner facade preserves the frozen constants, functions, and CLI while private modules own manifest, execution, ACDC, and command-line concerns.

- No function definitions in the AST census; constants/contracts only.

**Test definitions — 418 across 16 files.**

<!-- BRIDGE NOTE: Exact full source transfer continues below in the source repository; this bridge payload was interrupted by connector size constraints and is intentionally not asserted as byte-identical. -->
