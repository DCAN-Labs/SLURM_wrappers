# SLURM Wrappers
A set of SLURM-compliant codebase wrappers originally designed to interact with the Minnesota Supercomputing Institute (MSI). However, the wrappers should be able to function on all systems that use SLURM and have the codebase requirements installed. 

Most of these wrappers are tailored toward working with the S3 via `s3cmd` or `boto3`, but some are designed to work on disk and all can be adapted to work on disk. Using the S3, especially on MSI, is highly encouraged.

## Requirements
It is recommended that you go to the GitHub repository for the codebase itself in order to make sure all of the requirements are satisfied. This is something

## Wrapper Descriptions

- **ABCD-related:** [ABCD-BIDS](https://github.com/DCAN-Labs/abcd-hcp-pipeline) pipeline, [abcd-dicom2bids](https://github.com/DCAN-Labs/abcd-dicom2bids), and [ABCD-BIDS](https://github.com/DCAN-Labs/abcd-hcp-pipeline) + [file-mapper](https://github.com/DCAN-Labs/file-mapper) + DEAP derivative generation job submission.
- **BIBSnet:** [BIBSnet](https://github.com/DCAN-Labs/BIBSnet) single echo tier 1 and s3 job submission.
- **CABINET:** [CABINET](https://github.com/DCAN-Labs/CABINET) tier 1 and s3 job submission.
- **call_R:** TBD
- **continuous_submitter:** submission of any jobs at a given rate to pace queueing.
- **CuBIDS:** [CuBIDS](https://github.com/PennLINC/CuBIDS) s3 job submission (appending outputs).
- **CustomClean:** standalone (outside of ABCD-BIDS) [CustomClean](https://github.com/DCAN-Labs/CustomClean) s3 job submission.
- **DEAP-derivatives:** DEAP derivative generation s3 job submission.
- **disk_usage:** disk usage and file count s3 job submission.
- **file-mapper:** [file-mapper](https://github.com/DCAN-Labs/file-mapper) s3 job submission.
- **fMRIprep:** [fMRIprep](https://github.com/nipreps/fmriprep) s3 job submission.
- **HCPYA_BIDS_convert:** [HCP-YA](https://www.humanconnectome.org/study/hcp-young-adult/overview) BIDS conversion s3 job submission.
- **infant:** [BCP](https://fnih.org/our-programs/baby-connectome-project/) [DCAN-infant](https://github.com/DCAN-Labs/dcan-infant-pipeline), [BIBSnet](https://github.com/DCAN-Labs/BIBSnet) + [DCAN-infant](https://github.com/DCAN-Labs/dcan-infant-pipeline), general [DCAN-infant](https://github.com/DCAN-Labs/dcan-infant-pipeline), [nibabies](https://github.com/nipreps/nibabies), and [nibabies](https://github.com/nipreps/nibabies) + [XCP-D](https://github.com/PennLINC/xcp_d) s3 job submission.
- **infomap:** infomap (LINK TBD) s3 job submission.
- **intendedfors:** IntendedFor-matching s3 job submission.
- **motion_tsv_generation:** s3 job submission for generating motion TSV files from [ABCD-BIDS 0.0.3](https://github.com/DCAN-Labs/abcd-hcp-pipeline/releases/tag/v0.0.3) outputs.
- **move_subjects:** s3 job submission for moving files from one bucket to another.
- **QSIprep:** [QSIprep](https://github.com/PennLINC/qsiprep) s3 job submission.
- **s3_sync_external:** s3 job submission for syncing from one s3 host to another, utilizing 2 [s3 configs](https://dcan-labs-informational-guide.readthedocs.io/en/latest/s3/#setting-up-a-s3cfg).
- **s3_system_transfer_subset:** s3 job submission for syncing a file subset from one s3 host to another, utilizing 2 [s3 configs](https://dcan-labs-informational-guide.readthedocs.io/en/latest/s3/#setting-up-a-s3cfg).
- **simnibs_cifti_tools:** TBD