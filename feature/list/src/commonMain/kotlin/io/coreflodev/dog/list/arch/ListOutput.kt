package io.coreflodev.dog.list.arch

import io.coreflodev.common.arch.ScreenOutput

sealed class ListOutput : ScreenOutput {
    data object Loading : ListOutput()
    data object Retry : ListOutput()
    data class Display(val list: List<UiDog>) : ListOutput()
}

data class UiDog(val id: String, val image: String, val name: String)
