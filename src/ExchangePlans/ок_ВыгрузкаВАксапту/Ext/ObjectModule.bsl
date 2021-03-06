Процедура ПередЗаписью(Отказ)
	
	ОбменДанными.Загрузка = Истина;
	
	Если НЕ ЗначениеЗаполнено(КлючРегламентногоЗадания) Тогда
	
		КлючРегламентногоЗадания = Строка(Новый УникальныйИдентификатор);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменВключен Тогда
	
		СоздатьРегламентноеЗаданиеОповещениеПоКампании(); 
		
	Иначе
		
		УдалитьРегламентноеЗаданиеОповещениеПоКампании()
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура СоздатьРегламентноеЗаданиеОповещениеПоКампании() Экспорт

	Если НЕ ЗначениеЗаполнено(КлючРегламентногоЗадания) Тогда
		Возврат;
	КонецЕсли;
	
	Расписание = РасписаниеРегламентногоЗадания.Получить();
	Если НЕ ТипЗнч(Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("Ключ", 		КлючРегламентногоЗадания);
	СтруктураОтбора.Вставить("Метаданные", 	Метаданные.РегламентныеЗадания.ок_ВыгрузкаВАксапту);
	
	МассивРЗ = РегламентныеЗадания.ПолучитьРегламентныеЗадания(СтруктураОтбора);
	
	Если МассивРЗ.Количество() > 0 Тогда
		
		ТекущееРегламентноеЗадание = МассивРЗ[0];
		ТекущееРегламентноеЗадание.Расписание = Расписание;
		ТекущееРегламентноеЗадание.Использование = ОбменВключен;
		ТекущееРегламентноеЗадание.Записать();
		
	Иначе
		
		Если ОбменВключен Тогда
		
			Параметры = Новый Массив;
			Параметры.Добавить(Ссылка);
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("Метаданные", 								Метаданные.РегламентныеЗадания.ок_ВыгрузкаВАксапту);
			ПараметрыЗадания.Вставить("Ключ", 										КлючРегламентногоЗадания);
			ПараметрыЗадания.Вставить("Параметры", 									Параметры);
			ПараметрыЗадания.Вставить("Расписание", 								Расписание);
			ПараметрыЗадания.Вставить("Использование", 								Истина);
			ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 		10);
			ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 	3);
			ПараметрыЗадания.Вставить("Наименование",								СтрШаблон(НСтр("ru = 'Выгрузка в аксапту - узел ""%1""'"), Ссылка));
			
			РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
			
		КонецЕсли;
		
	КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры 

Процедура УдалитьРегламентноеЗаданиеОповещениеПоКампании() Экспорт

	Если НЕ ЗначениеЗаполнено(КлючРегламентногоЗадания) Тогда
		Возврат;
	КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("Ключ", 		КлючРегламентногоЗадания);
	СтруктураОтбора.Вставить("Метаданные", 	Метаданные.РегламентныеЗадания.ок_ВыгрузкаВАксапту);
	
	МассивРЗ = РегламентныеЗадания.ПолучитьРегламентныеЗадания(СтруктураОтбора);
	
	Для каждого ТекущееРегламентноеЗадание Из МассивРЗ Цикл
	
		ТекущееРегламентноеЗадание.Удалить();
	
	КонецЦикла; 
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры
