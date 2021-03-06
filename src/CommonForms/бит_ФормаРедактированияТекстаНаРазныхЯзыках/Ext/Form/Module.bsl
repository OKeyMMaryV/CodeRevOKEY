
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РедактируемыйТекст") Тогда
	
		РедактируемыйТекст = Параметры.РедактируемыйТекст;
	
	КонецЕсли; 
	
	// Разберем строку на языки
	СтрЯзыки = бит_ОбщегоНазначенияКлиентСервер.РазобратьТекстНаЯзыки(РедактируемыйТекст);
	
	// Получим доступные языки
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	бит_Языки.КодЯзыка
	               |ИЗ
	               |	Справочник.бит_Языки КАК бит_Языки
	               |ГДЕ
	               |	(НЕ бит_Языки.ПометкаУдаления)";
				   
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		КодЯзыка = СокрЛП(Выборка.КодЯзыка);
		Если НЕ СтрЯзыки.Свойство(КодЯзыка) Тогда
		
			СтрЯзыки.Вставить(КодЯзыка,"");
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	// Заполним таблицу с текстом на разных языках.
	Для каждого КиЗ Из СтрЯзыки Цикл
	
		НоваяСтрока = ТаблицаТекст.Добавить();
		НоваяСтрока.КодЯзыка = КиЗ.Ключ;
		НоваяСтрока.Текст    = КиЗ.Значение;
	
	КонецЦикла; 
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаТекст

&НаКлиенте
Процедура ТаблицаТекстПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	СтрЯзыки = Новый Структура;
	
	Для каждого СтрокаТаблицы Из ТаблицаТекст Цикл
		
		Если НЕ ПустаяСтрока(СтрокаТаблицы.Текст) Тогда
			
			СтрЯзыки.Вставить(СтрокаТаблицы.КодЯзыка,СтрокаТаблицы.Текст);
			
		КонецЕсли; 
	
	КонецЦикла; 
	
	РедактируемыйТекст = бит_ОбщегоНазначенияКлиентСервер.СформироватьТекстНаРазныхЯзыках(СтрЯзыки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть(РедактируемыйТекст);
	
КонецПроцедуры

#КонецОбласти
