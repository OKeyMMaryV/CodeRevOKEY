#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-07-25 (#4214) 
	//ТарификацияБП.КонстантаФункциональностиПередЗаписью(Метаданные().Имя, Значение, Отказ);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-07-25 (#4214) 
КонецПроцедуры

#КонецОбласти

#КонецЕсли
