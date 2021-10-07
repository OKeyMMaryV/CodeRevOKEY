﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаЗаполнения".
// 
&НаСервере
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ПервоначальноеЗаполнениеДокумента();
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "ПриКопировании".
// 
&НаСервере
Процедура ПриКопировании(ОбъектКопирования)
	
	ПервоначальноеЗаполнениеДокумента(ОбъектКопирования);
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью".
// 
&НаСервере
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
	
	Если Не Отказ Тогда
		
		// Выполним синхронизацию пометки на удаление объекта и дополнительных файлов.
		бит_ХранениеДополнительнойИнформации.СинхронизацияПометкиНаУдалениеУДополнительныхФайлов(ЭтотОбъект);
		
	КонецЕсли; // Если Не Отказ Тогда
	
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	
		
КонецПроцедуры // ПриЗаписи()

// Процедура - обработчик события "ОбработкаПроведения".
// 
&НаСервере
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	

	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = бит_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Проверка ручной корректировки.
	Если бит_ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка, Отказ, Заголовок, ЭтотОбъект, Ложь) Тогда
		Возврат
	КонецЕсли;
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураТаблиц 		= ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента);	
	
	// Получим курсы валют, неоходимые для выполнения пересчетов.
	ВидыКурсов = Новый Структура("Упр,Регл,МУ");
	СтруктураКурсыВалют = бит_му_ОбщегоНазначения.ПолучитьСтруктуруКурсовВалют(ЭтотОбъект, СтруктураШапкиДокумента.Дата, ВидыКурсов);
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, СтруктураКурсыВалют, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
// 
&НаСервере
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	бит_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция готовит таблицы документа для проведения.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
// 
// Возвращаемое значение:
//  СтруктураТаблиц - Структура.
// 
&НаСервере
Функция ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента) Экспорт
	
	СтруктураТаблиц = Новый Структура;
	
	// Табличная часть "Гудвилл"
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_му_КонсолидационныеКорректировкиГудвилл.Организация,
	               |	бит_му_КонсолидационныеКорректировкиГудвилл.НаДатуПриобретения,
	               |	бит_му_КонсолидационныеКорректировкиГудвилл.НаДатуНачала,
	               |	бит_му_КонсолидационныеКорректировкиГудвилл.НаДатуОкончания
	               |ИЗ
	               |	Документ.бит_му_КонсолидационныеКорректировки.Гудвилл КАК бит_му_КонсолидационныеКорректировкиГудвилл
	               |ГДЕ
	               |	бит_му_КонсолидационныеКорректировкиГудвилл.Ссылка = &Ссылка";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаГудвилл = РезультатЗапроса.Выгрузить();
	
	СтруктураТаблиц.Вставить("Гудвилл", ТаблицаГудвилл);
	
	// Табличная часть "Капитал"
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_му_КонсолидационныеКорректировкиКапитал.Организация,
	               |	бит_му_КонсолидационныеКорректировкиКапитал.Счет,
	               |	бит_му_КонсолидационныеКорректировкиКапитал.Сумма
	               |ИЗ
	               |	Документ.бит_му_КонсолидационныеКорректировки.Капитал КАК бит_му_КонсолидационныеКорректировкиКапитал
	               |ГДЕ
	               |	бит_му_КонсолидационныеКорректировкиКапитал.Ссылка = &Ссылка";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаКапитал = РезультатЗапроса.Выгрузить();
	
	СтруктураТаблиц.Вставить("Капитал", ТаблицаКапитал);
	
	Возврат СтруктураТаблиц;
	
КонецФункции // ПодготовитьТаблицыДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение созданного/скопированного документа.
// 
// Параметры:
//  ПараметрОбъектКопирования - ДокументОбъект.
// 
&НаСервере
Процедура ПервоначальноеЗаполнениеДокумента(ПараметрОбъектКопирования = Неопределено)
	
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
												,бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
												,ПараметрОбъектКопирования);
												
	Если ПараметрОбъектКопирования <> Неопределено Тогда
		СоставНРП.Очистить();
		Капитал.Очистить();
	Иначе
		ОбъектСистемы = бит_УправлениеПользователямиСервер.ПолучитьЗначениеПоУмолчанию(ПланыВидовХарактеристик.бит_НастройкиПользователей.ОсновнойРегистрБухгалтерииУУ);
	КонецЕсли;												
	
КонецПроцедуры // ПервоначальноеЗаполнениеДокумента()

// Процедура выполняет движения по регистрам.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  СтруктураТаблиц 		- Структура.
//  СтруктураКурсыВалют 	- Структура.
//  Отказ 					- Булево.
//  Заголовок 				- Строка.
// 
&НаСервере
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, СтруктураКурсыВалют, Отказ, Заголовок)
	
	ТаблицаДанных = СтруктураТаблиц.Гудвилл;
	
	Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		// Сформируем проводки по табличной части "Гудвилл".
		СформироватьЗаписьГудвилл(СтруктураШапкиДокумента, СтрокаТаблицы, СтруктураКурсыВалют);
		
	КонецЦикла;
	
	ТаблицаДанных = СтруктураТаблиц.Капитал;
	
	Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		// Сформируем проводки по табличной части "Капитал".
		СформироватьЗаписьКапитал(СтруктураШапкиДокумента, СтрокаТаблицы, СтруктураКурсыВалют);
		
	КонецЦикла;
	
	// Сформируем проводки по нераспределенной прибыли.
	СформироватьЗаписьНПР(СтруктураШапкиДокумента, СтруктураКурсыВалют);
	
КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура формирует движение по строке табличной части "Гудвилл".
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  СтрокаТаблицы - Строка таблицы значений.
//  СтруктураКурсыВалют 	- Структура.
// 
&НаСервере
Процедура СформироватьЗаписьГудвилл(СтруктураШапкиДокумента, СтрокаТаблицы, СтруктураКурсыВалют)
	
	// ДТ Счет Гудвилл КТ Счет вспомогательный, на сумму начала периода.
	Запись = Движения[ОбъектСистемы.ИмяОбъекта].Добавить();
	
	// Заполнение атрибутов записи.
	СтруктураПараметров = Новый Структура("Организация,Период,Валюта,СчетДт,СчетКт,Сумма,Содержание"
										 ,СтруктураШапкиДокумента.Организация
										 ,СтруктураШапкиДокумента.Дата
										 ,СтруктураКурсыВалют["Упр"].Валюта
										 ,СтруктураШапкиДокумента.СчетГудвилла
										 ,СтруктураШапкиДокумента.СчетВспомогательный
										 ,СтрокаТаблицы.НаДатуНачала
										 ,СтрокаТаблицы.Организация);
										 
	бит_му_ОбщегоНазначения.ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);											   
	Запись.СуммаУпр = СтрокаТаблицы.НаДатуНачала;
	
	// Выполним валютные пересчеты.
	ВыполнитьВалютныеПересчетыЗаписи(СтруктураПараметров, Запись, СтруктураКурсыВалют);
	
	// ДТ Счет списания обесценения Гудвилла КТ Счет Гудвилла, на разницу сумм на дату начала и дату окончания.
	Запись = Движения[ОбъектСистемы.ИмяОбъекта].Добавить();
	
	// Заполнение атрибутов записи.
	СтруктураПараметров = Новый Структура("Организация,Период,Валюта,СчетДт,СчетКт,Сумма,Содержание"
										 ,СтруктураШапкиДокумента.Организация
										 ,СтруктураШапкиДокумента.Дата
										 ,СтруктураКурсыВалют["Упр"].Валюта
										 ,СтруктураШапкиДокумента.СчетВспомогательный
										 ,СтруктураШапкиДокумента.СчетСписанияОбесцененияГудвилла
										 ,СтрокаТаблицы.НаДатуНачала - СтрокаТаблицы.НаДатуОкончания
										 ,СтрокаТаблицы.Организация);
										 
	бит_му_ОбщегоНазначения.ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);											   
	Запись.СуммаУпр = СтрокаТаблицы.НаДатуНачала - СтрокаТаблицы.НаДатуОкончания;
	
	// Выполним валютные пересчеты.
	ВыполнитьВалютныеПересчетыЗаписи(СтруктураПараметров, Запись, СтруктураКурсыВалют);
	
КонецПроцедуры

// Процедура формирует движение по строке табличной части "Капитал".
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  СтрокаТаблицы - Строка таблицы значений.
//  СтруктураКурсыВалют 	- Структура.
// 
&НаСервере
Процедура СформироватьЗаписьКапитал(СтруктураШапкиДокумента, СтрокаТаблицы, СтруктураКурсыВалют)
	
	// Дт Счет вспомогательный Кт Счет капитала, сумма.
	Запись = Движения[ОбъектСистемы.ИмяОбъекта].Добавить();
	
	// Заполнение атрибутов записи.
	СтруктураПараметров = Новый Структура("Организация,Период,Валюта,СчетДт,СчетКт,Сумма,Содержание"
										 ,СтруктураШапкиДокумента.Организация
										 ,СтруктураШапкиДокумента.Дата
										 ,СтруктураКурсыВалют["Упр"].Валюта
										 ,СтруктураШапкиДокумента.СчетВспомогательный
										 ,СтрокаТаблицы.Счет
										 ,СтрокаТаблицы.Сумма
										 ,СтрокаТаблицы.Организация);
										 
	бит_му_ОбщегоНазначения.ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);											   
	Запись.СуммаУпр = СтрокаТаблицы.Сумма;
	
	// Выполним валютные пересчеты.
	ВыполнитьВалютныеПересчетыЗаписи(СтруктураПараметров, Запись, СтруктураКурсыВалют);
	
КонецПроцедуры

// Процедура формирует итоговое движение по нераспределенной прибыли.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  СтруктураКурсыВалют 	- Структура.
// 
&НаСервере
Процедура СформироватьЗаписьНПР(СтруктураШапкиДокумента, СтруктураКурсыВалют)
	
	// ДТ Счет вспомогательный КТ Основной счет НРП, на сумму НРП Итого.
	Запись = Движения[ОбъектСистемы.ИмяОбъекта].Добавить();
	
	// Заполнение атрибутов записи.
	СтруктураПараметров = Новый Структура("Организация,Период,Валюта,СчетДт,СчетКт,Сумма,Содержание"
										 ,СтруктураШапкиДокумента.Организация
										 ,СтруктураШапкиДокумента.Дата
										 ,СтруктураКурсыВалют["Упр"].Валюта
										 ,СтруктураШапкиДокумента.СчетВспомогательный
										 ,СтруктураШапкиДокумента.ОсновнойСчетНПР
										 ,СтруктураШапкиДокумента.СуммаНПРИтого
										 ,СтруктураШапкиДокумента.Организация);
										 
	бит_му_ОбщегоНазначения.ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);											   
	Запись.СуммаУпр = СтруктураШапкиДокумента.СуммаНПРИтого;
	
	// Выполним валютные пересчеты.
	ВыполнитьВалютныеПересчетыЗаписи(СтруктураПараметров, Запись, СтруктураКурсыВалют);
	
КонецПроцедуры

// Функция определяет будут ли движения по международному учету.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Результат - Булево.
// 
Функция ЕстьМеждународныйУчет()

	Если Метаданные.РегистрыБухгалтерии[ОбъектСистемы.ИмяОбъекта].Ресурсы.Найти("СуммаМУ") = Неопределено Тогда
		ЕстьМеждународныйУчет = Ложь;
	Иначе
		ЕстьМеждународныйУчет = Истина;
	КонецЕсли;

	Возврат ЕстьМеждународныйУчет;
	
КонецФункции // ЕстьМеждународныйУчет()	

// Процедура выполняет расчет сумм "Регламентного и международного и управленческого учета".
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  Запись					- РегистрБухгалтерииЗапись.бит_Дополнительный.
//  СтруктураКурсыВалют 	- Структура.
// 
&НаСервере
Процедура ВыполнитьВалютныеПересчетыЗаписи(СтруктураПараметров, Запись, СтруктураКурсыВалют)
	
	Запись.СуммаРегл = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Запись.СуммаУпр,
																	СтруктураКурсыВалют["Упр"].Валюта, СтруктураКурсыВалют["Регл"].Валюта,
																	СтруктураКурсыВалют["Упр"].Курс, СтруктураКурсыВалют["Регл"].Курс,
																	СтруктураКурсыВалют["Упр"].Кратность, СтруктураКурсыВалют["Регл"].Кратность);
	Если ЕстьМеждународныйУчет() Тогда
		Запись.СуммаМУ = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Запись.СуммаУпр,
																	СтруктураКурсыВалют["Упр"].Валюта, СтруктураКурсыВалют["МУ"].Валюта,
																	СтруктураКурсыВалют["Упр"].Курс, СтруктураКурсыВалют["МУ"].Курс,
																	СтруктураКурсыВалют["Упр"].Кратность, СтруктураКурсыВалют["МУ"].Кратность);
	КонецЕсли;																	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
