﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс	

// Обработчик обновления БРО.
//
// Вызывается при первом заполнении либо в случае необходимости обновления справочника регламентированных отчетов.
//
Процедура ЗаполнитьСписокРегламентированныхОтчетов() Экспорт
    	    			
	ОбработкаОбновлениеОтчетов = Обработки.ОбновлениеРегламентированнойОтчетности.Создать();

	ДеревоОтчетов = ОбработкаОбновлениеОтчетов.ПолучитьСписокОтчетов();

	Если ДеревоОтчетов.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ОбработкаОбновлениеОтчетов.ЗаполнитьСписокОтчетов(ДеревоОтчетов);
	
КонецПроцедуры

// Обработчик обновления БРО.
//
// Вызывается при первом заполнении либо в случае необходимости обновления справочника регламентированных отчетов.
//
Процедура УстановитьСнятьПометкуНаУдаление() Экспорт
	
	ОбработкаОбновлениеОтчетов = Обработки.ОбновлениеРегламентированнойОтчетности.Создать();

	ДеревоОтчетов = ОбработкаОбновлениеОтчетов.ПолучитьСписокОтчетов();

	Если ДеревоОтчетов.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ОбработкаОбновлениеОтчетов.УстановитьСнятьПометкуНаУдаление(ДеревоОтчетов);
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.13.5
//
Процедура УдалитьРеглОтчетИсполнениеКонтрактовГОЗИзГруппыОтчетностьПрочая() Экспорт
	
	НачатьТранзакцию();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	|	РегламентированныеОтчеты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты
	|ГДЕ
	|	РегламентированныеОтчеты.Наименование = &НаименованиеЭлемента
	|	И РегламентированныеОтчеты.ЭтоГруппа = ЛОЖЬ
	|	И РегламентированныеОтчеты.Родитель.Наименование = &НаименованиеГруппы";
	
	Запрос.УстановитьПараметр("НаименованиеЭлемента", "Исполнение контрактов ГОЗ");
	Запрос.УстановитьПараметр("НаименованиеГруппы",   "Отчетность прочая");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		УдаляемыйОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		Если УдаляемыйОбъект <> Неопределено Тогда
			ОбновлениеИнформационнойБазы.УдалитьДанные(УдаляемыйОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Обработчик обновления БРО 1.0.1.52
//
Процедура УдалитьПовторяющиесяГруппыИЭлементыВСправочникеРеглОтчетов() Экспорт
	
	НачатьТранзакцию();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	РегламентированныеОтчеты.Ссылка КАК Ссылка,
						  |	РегламентированныеОтчеты.Наименование КАК Наименование
						  |ИЗ
						  |	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты
						  |ГДЕ
						  |	РегламентированныеОтчеты.ЭтоГруппа = ИСТИНА");
						  
	ТаблицаРезультатов = Запрос.Выполнить().Выгрузить();
	
	Пока ТаблицаРезультатов.Количество() > 0 Цикл
		
		НайденныеСтроки = ТаблицаРезультатов.НайтиСтроки(Новый Структура("Наименование", ТаблицаРезультатов[0].Наименование));
		
		Если НайденныеСтроки.Количество() > 1 Тогда
			
			Для НомерНайденнойСтроки = 1 По НайденныеСтроки.Количество() - 1 Цикл
				
				УдаляемыйОбъект = НайденныеСтроки[НомерНайденнойСтроки].Ссылка.ПолучитьОбъект();
				
				Если НЕ УдаляемыйОбъект = Неопределено Тогда
					ОбновлениеИнформационнойБазы.УдалитьДанные(УдаляемыйОбъект);
				КонецЕсли;
								
				ТаблицаРезультатов.Удалить(НайденныеСтроки[НомерНайденнойСтроки]);
				
			КонецЦикла;
			
			ТаблицаРезультатов.Удалить(0);
						
		Иначе
			
			ТаблицаРезультатов.Удалить(0);
			
		КонецЕсли;
				
	КонецЦикла;
					
	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	РегламентированныеОтчеты.Ссылка КАК Ссылка,
						  |	РегламентированныеОтчеты.ИсточникОтчета КАК ИсточникОтчета
						  |ИЗ
						  |	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты
						  |ГДЕ
						  |	РегламентированныеОтчеты.ЭтоГруппа = ЛОЖЬ");
						  
	ТаблицаРезультатов = Запрос.Выполнить().Выгрузить();
	
	Пока ТаблицаРезультатов.Количество() > 0 Цикл
		
		НайденныеСтроки = ТаблицаРезультатов.НайтиСтроки(Новый Структура("ИсточникОтчета", ТаблицаРезультатов[0].ИсточникОтчета));
		
		Если НайденныеСтроки.Количество() > 1 Тогда
			
			Для НомерНайденнойСтроки = 1 По НайденныеСтроки.Количество() - 1 Цикл
								
				УдаляемыйОбъект = НайденныеСтроки[НомерНайденнойСтроки].Ссылка.ПолучитьОбъект();
				
				Если НЕ УдаляемыйОбъект = Неопределено Тогда
				   
					Если УдаляемыйОбъект.Предопределенный Тогда
						
						УдаляемыйОбъект.ИмяПредопределенныхДанных = "";
						
						УдаляемыйОбъект.Записать();
						
					КонецЕсли;
				   
					ОбновлениеИнформационнойБазы.УдалитьДанные(УдаляемыйОбъект);
					
				КонецЕсли;
				
				ТаблицаРезультатов.Удалить(НайденныеСтроки[НомерНайденнойСтроки]);
				
			КонецЦикла;
			
			ТаблицаРезультатов.Удалить(0);
						
		Иначе
			
			ТаблицаРезультатов.Удалить(0);
			
		КонецЕсли;
				
	КонецЦикла;
				
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Обработчик обновления БРО.
//
Процедура ОчиститьВнешниеРеглОтчеты() Экспорт
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	РегламентированныеОтчеты.Ссылка КАК Ссылка,
						  |	РегламентированныеОтчеты.ИсточникОтчета КАК ИсточникОтчета
						  |ИЗ
						  |	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты
						  |ГДЕ
						  |	РегламентированныеОтчеты.ВнешнийОтчетИспользовать = ИСТИНА");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Метаданные.Документы.Найти(Выборка.ИсточникОтчета) <> Неопределено 
			ИЛИ Метаданные.Отчеты.Найти(Выборка.ИсточникОтчета) <> Неопределено Тогда
			ОбъектРеглОтчет = Выборка.Ссылка.ПолучитьОбъект();
			ОбъектРеглОтчет.ВнешнийОтчетИспользовать = Ложь;
			ОбъектРеглОтчет.ВнешнийОтчетХранилище = Неопределено;
			ОбъектРеглОтчет.ВнешнийОтчетВерсия = "";
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектРеглОтчет, , Истина);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает реквизиты справочника, которые образуют естественный ключ
// для элементов справочника.
//
// Возвращаемое значение:
//   Массив - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить("ИсточникОтчета");
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли