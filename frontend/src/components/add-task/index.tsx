import { Box, Button, Stack, TextField } from "@mui/material";
import { FunctionComponent } from "react";
import { FormProvider, useForm } from "react-hook-form";

const AddTask: FunctionComponent = () => {
    const methods = useForm<Task>({
        defaultValues: {
            task: "",
            endTime: "",
        },
    });

    const { handleSubmit, register } = methods;
    const onSubmit = async (inputData: Task) => {
        console.log(inputData);
    };

    return (
        <Box>
            <FormProvider {...methods}>
                <form onSubmit={handleSubmit(onSubmit)}>
                    <Stack>
                        <TextField label="Add Task" {...register("task")} />
                        <Button type="submit">add task</Button>
                    </Stack>
                </form>
            </FormProvider>
        </Box>
    );
};

export default AddTask;