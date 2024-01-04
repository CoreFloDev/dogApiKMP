package io.coreflodev.dog.list.arch

import io.coreflodev.dog.list.domain.Result
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.scan

class ListUiReducer {

    operator fun invoke()  :(Flow<Result.UiUpdate>) -> Flow<ListOutput> = { stream ->
        stream.scan(ListOutput.Loading as ListOutput) { _, new ->
            when (new) {
                is Result.UiUpdate.Display -> ListOutput.Display(new.uiDogs)
                Result.UiUpdate.Error -> ListOutput.Retry
                Result.UiUpdate.Loading -> ListOutput.Loading
            }
        }
    }
}
