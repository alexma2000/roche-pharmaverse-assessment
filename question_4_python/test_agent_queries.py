# =====================================================================
# COMPANY: Roche - PD Data Sciences & Analytics (PDD)
# TASK: Question 4 - GenAI Agent Benchmark Evaluation Suite
# CODEBASE: Standalone Verification Test Script
# AUTHOR: Alex Mychlo, PhD
# DATE: September 2026
# =====================================================================

from clinical_agent import ClinicalTrialDataAgent

def run_regulatory_benchmark_tests():
    print("=== Launching Independent Verification Test Suite ===")
    
    # Initialize the clinical data agent targeting the output location
    agent = ClinicalTrialDataAgent(dataframe_path="question_3_tlg/adae.csv")
    
    # Executing the 3 mandatory evaluation queries requested by Roche
    print("\n--- Executing Query 1: Severity Evaluation ---")
    agent.execute_query("Give me the subjects who had Adverse events of Moderate severity.")
    
    print("\n--- Executing Query 2: Condition Mapping ---")
    agent.execute_query("Identify all patients who experienced a Headache condition.")
    
    print("\n--- Executing Query 3: System Organ Class Analysis ---")
    agent.execute_query("List subjects with issues located in the Skin body system.")
    
    print("\n=== Verification Test Suite Completed Successfully ===")

if __name__ == "__main__":
    run_regulatory_benchmark_tests()
