# acep_clean current behavior is characterized

    {
      "type": "character",
      "attributes": {},
      "value": ["suteba paro reclaman mejoras salariales", "marcha mar plata"]
    }

# acep_count current behavior is characterized

    {
      "type": "integer",
      "attributes": {},
      "value": [3, 2, 0]
    }

# acep_svo stable return schemas are characterized

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["acep_annotate_svo", "acep_pro_svo", "acep_list_svo", "acep_sp", "acep_lista_lemmas", "acep_no_procesadas"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["class", "dim", "names"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["tokenIndex", "data.table", "data.frame"]
            },
            {
              "type": "integer",
              "attributes": {},
              "value": [15, 25]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["doc_id", "sentence", "token_id", "token", "lemma", "pos", "parent", "relation", "entity", "nounphrase", "whitespace", "is_upper", "is_title", "is_quote", "ent_iob_", "ent_iob", "is_left_punct", "is_right_punct", "morph", "sent", "s_v_o", "s_v_o_id", "s_v_o_fill", "s_p", "conjugaciones"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["class", "dim", "names"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["data.frame"]
            },
            {
              "type": "integer",
              "attributes": {},
              "value": [1, 13]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["doc_id", "oracion_id", "eventos", "sujeto_svo", "root", "objeto", "sujeto", "predicado", "verbo", "lemma_verb", "aux_verbos", "entidades", "sust_pred"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["class", "dim", "names"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["data.frame"]
            },
            {
              "type": "integer",
              "attributes": {},
              "value": [1, 6]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["doc_id", "oracion_id", "eventos", "sujeto", "verbo", "objeto"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["class", "dim", "names"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["data.frame"]
            },
            {
              "type": "integer",
              "attributes": {},
              "value": [1, 9]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["doc_id", "oracion_id", "sujeto", "predicado", "verbo", "lemma_verb", "aux_verbos", "entidades", "sust_pred"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["class", "dim", "names"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["data.frame"]
            },
            {
              "type": "integer",
              "attributes": {},
              "value": [8, 2]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["lemma", "n"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["class", "dim", "names"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["tokenIndex", "data.table", "data.frame"]
            },
            {
              "type": "integer",
              "attributes": {},
              "value": [0, 3]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["doc_id", "oracion_id", "oracion"]
            }
          ]
        }
      ]
    }

# public exports and hot-path formals are snapshotted

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["exports", "formals"]
        }
      },
      "value": [
        {
          "type": "character",
          "attributes": {},
          "value": ["%>%", "acep_claude", "acep_clean", "acep_clear_regex_cache", "acep_context", "acep_corpus", "acep_count", "acep_db", "acep_detect", "acep_extract", "acep_frec", "acep_gemini", "acep_gpt", "acep_gpt_schema", "acep_int", "acep_load_base", "acep_may", "acep_min", "acep_ollama", "acep_ollama_setup", "acep_openrouter", "acep_pipeline", "acep_plot_rst", "acep_plot_st", "acep_postag", "acep_postag_hibrido", "acep_process_chunks", "acep_regex_cache_size", "acep_result", "acep_sst", "acep_svo", "acep_together", "acep_token", "acep_token_plot", "acep_token_table", "acep_upos", "pipe_clean", "pipe_count", "pipe_intensity", "pipe_timeseries"]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["acep_clean", "acep_count", "acep_svo"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {
                "names": {
                  "type": "character",
                  "attributes": {},
                  "value": ["x", "tolower", "rm_cesp", "rm_emoji", "rm_hashtag", "rm_users", "rm_punt", "rm_num", "rm_url", "rm_meses", "rm_dias", "rm_stopwords", "rm_shortwords", "rm_newline", "rm_whitespace", "other_sw", "u"]
                }
              },
              "value": ["", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "TRUE", "NULL", "1"]
            },
            {
              "type": "character",
              "attributes": {
                "names": {
                  "type": "character",
                  "attributes": {},
                  "value": ["texto", "dic", "use_cache"]
                }
              },
              "value": ["", "", "TRUE"]
            },
            {
              "type": "character",
              "attributes": {
                "names": {
                  "type": "character",
                  "attributes": {},
                  "value": ["acep_tokenindex", "prof_s", "prof_o", "u"]
                }
              },
              "value": ["", "3", "3", "1"]
            }
          ]
        }
      ]
    }

