from subprocess import Popen, PIPE, STDOUT

def awscli():
    p = Popen(["/opt/awscli/aws", "--version"], stdout=PIPE, stderr=STDOUT)
    return p.stdout.read()


def lambda_handler(event, context):
    out = awscli()
    return {
        'statusCode': 200,
        'body': out
    }
