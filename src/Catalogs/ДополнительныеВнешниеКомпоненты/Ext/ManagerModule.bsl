﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Сохраняет внешнюю компоненту в информационной базе
//
// Параметры:
//  Адрес - Строка - адрес временного хранилища c двоичными данными внешней компоненты.
//
Процедура СохранитьВнешнююКомпонентуВИнформационнойБазе(Адрес) Экспорт
	
	ИнформацияОВК = ДополнительныеВнешниеКомпонентыВызовСервера.ИнформацияОВнешнейКомпоненте(Адрес);
	Если ИнформацияОВК = Неопределено ИЛИ Не ИнформацияОВК.Свойство("URLИнфо") Тогда
		Возврат
	КонецЕсли;
	
	НайденныйЭлемент = Справочники.ДополнительныеВнешниеКомпоненты.НайтиПоРеквизиту("Идентификатор", ИнформацияОВК.ИмяМодуля);
	Если ЗначениеЗаполнено(НайденныйЭлемент) Тогда
		ОбъектСправочника = НайденныйЭлемент.ПолучитьОбъект();
	Иначе
		ОбъектСправочника = Справочники.ДополнительныеВнешниеКомпоненты.СоздатьЭлемент();
	КонецЕсли;
	
	ОбъектСправочника.Наименование = ИнформацияОВК.Название;
	ОбъектСправочника.Версия = ИнформацияОВК.Версия;
	ДвоичныеДанныеВК = ПолучитьИзВременногоХранилища(Адрес);
	ОбъектСправочника.ДанныеВК = Новый ХранилищеЗначения(ДвоичныеДанныеВК, Новый СжатиеДанных(9));
	ОбъектСправочника.Идентификатор = ИнформацияОВК.ИмяМодуля;
	ОбъектСправочника.Адрес = ИнформацияОВК.URLИнфо;
	ОбъектСправочника.ПометкаУдаления = Ложь;
	ОбъектСправочника.Записать();
	
КонецПроцедуры

// Получает параметры внешней компоненты.
//
// Параметры:
//  ПутьКФайлуИнформации - Строка - путь к информационному файлу.
// 
// Возвращаемое значение:
//  Структура - информация о ВК. Содержит следующие поля:
//     * ИмяМодуля - Строка - регистрируемое название модуля в ОС
//     * Название - Строка - название модуля для вывода пользователю
//     * Версия - Строка - версия модуля
//     * URLВК - Строка - адрес в интернете для скачивания компоненты
//     * URLИнфо - Строка - адрес в интернете для скачивания информационного файла.
//
Функция ПараметрыВК(ПутьКФайлуИнформации) Экспорт
	
	Попытка
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ПутьКФайлуИнформации);
		ЭД = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("ИмяМодуля", ЭД.progid);
		СтруктураВозврата.Вставить("Название", ЭД.name);
		СтруктураВозврата.Вставить("Версия", ЭД.version);
		Если ТипЗнч(ЭД.urladdin) = Тип("Строка") Тогда
			СтруктураВозврата.Вставить("URLВК", ЭД.urladdin);
		КонецЕсли;
		Если ТипЗнч(ЭД.urladdininfo) = Тип("Строка") Тогда
			СтруктураВозврата.Вставить("URLИнфо", ЭД.urladdininfo);
		КонецЕсли;

		Возврат СтруктураВозврата;
	Исключение
		Операция = НСтр("ru = 'Чтение файла информации о внешней компоненте.'");
		ТекстСообщения = НСтр("ru = 'При чтении информации о внешней компоненте произошла ошибка.'");
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(Операция, ТекстОшибки);
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
КонецФункции

// Скачивает информационный файл внешней компоненты через интернет в фоновом процессе и определяет ее идентификатор.
//
// Параметры:
//  Параметры - Структура - параметры загрузки внешней компоненты. Содержит следующие поля:
//                 * URLВК - Строка - адрес файла в интернет
//  Адрес - Строка - адрес временного хранилища, содержащий результат выполнения процедуры.
//
Процедура СкачатьВнешнююКомпонентуПоПрямойСсылке(Параметры, Адрес) Экспорт
	
	ВремФайл = ПолучитьИмяВременногоФайла("xml");
	ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
	ПараметрыПолучения.Таймаут = 1260;
	ПараметрыПолучения.ПутьДляСохранения = ВремФайл;
	РезультатВКФайл = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(
			Параметры.URLВК, ПараметрыПолучения);
	Если РезультатВКФайл.Статус Тогда
		СохранитьВнешнююКомпонентуВИнформационнойБазе(РезультатВКФайл.Путь);
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось скачать файл внешней компоненты по адресу: %1
									|Описание: %2'");
		Если РезультатВКФайл.Свойство("КодСостояния") Тогда
			ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = 'Код ошибки: %3'");
			ТекстСообщения = СтрШаблон(
				ТекстСообщения, Параметры.URLВК, РезультатВКФайл.СообщениеОбОшибке, РезультатВКФайл.КодСостояния);
		Иначе
			ТекстСообщения = СтрШаблон(ТекстСообщения, Параметры.URLВК, РезультатВКФайл.СообщениеОбОшибке);
		КонецЕсли;
		
		ВидОперации = НСтр("ru = 'Загрузка внешней компоненты из интернет.'");
			
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстСообщения);
		
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	УдалитьФайлы(ВремФайл);
	
КонецПроцедуры

// Получает двоичные данные внешней компоненты
//
// Параметры:
//  Идентификатор - Строка - уникальное название модуля.
// 
// Возвращаемое значение:
//  ДвоичныеДанные - данные внешней компоненты.
//
Функция ДвоичныеДанныеВнешнейКомпоненты(Идентификатор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ВнешниеКомпоненты.ДанныеВК
	               |ИЗ
	               |	Справочник.ДополнительныеВнешниеКомпоненты КАК ВнешниеКомпоненты
	               |ГДЕ
	               |	ВнешниеКомпоненты.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДанныеВК.Получить();
	КонецЕсли;
	
КонецФункции

// Скачивает внешнюю компоненту по URL информационного файла.
//
// Параметры:
//  Параметры - Структура - параметры загрузки внешней компоненты. Содержит следующие поля:
//                 * URLИнфо - Строка - адрес информационного файла в интернет
//  Адрес - Строка - адрес временного хранилища, содержащий результат выполнения процедуры.
//
Процедура СкачатьВнешнююКомпоненту(Параметры, Адрес = Неопределено) Экспорт
	
	ВремФайл = ПолучитьИмяВременногоФайла("xml");
	ПараметрыПолучения = Новый Структура("Таймаут, ПутьДляСохранения", 20, ВремФайл);
	РезультатИнфоФайл = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(Параметры.URLИнфо, ПараметрыПолучения);
	Если РезультатИнфоФайл.Статус Тогда
		ПараметрыВК = ПараметрыВК(ВремФайл);
		УдалитьВременныеФайлы(ВремФайл);
		ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
		ПараметрыПолучения.Таймаут = 60;
		РезультатВКФайл = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(
			ПараметрыВК.URLВК, ПараметрыПолучения);
		Если РезультатВКФайл.Статус Тогда
			СохранитьВнешнююКомпонентуВИнформационнойБазе(РезультатВКФайл.Путь);
		Иначе
			ТекстСообщения = НСтр("ru = 'Не удалось скачать файл внешней компоненты: %1
										|Описание: %2'");
			ТекстОшибки =  НСтр("ru = 'Не удалось скачать файл внешней компоненты: %1
									|Описание: %2
									|URL: %3'");
			Если РезультатИнфоФайл.Свойство("КодСостояния") Тогда
				ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = 'Код ошибки: %3'");
				ТекстСообщения = СтрШаблон(
					ТекстСообщения, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, РезультатВКФайл.КодСостояния);
				ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Код ошибки: %4'");
				ТекстОшибки = СтрШаблон(ТекстОшибки, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, ПараметрыВК.URLВК,
					РезультатВКФайл.КодСостояния);
			Иначе
				ТекстСообщения = СтрШаблон(ТекстСообщения, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке);
				ТекстОшибки = СтрШаблон(ТекстОшибки, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, ПараметрыВК.URLВК);
			КонецЕсли;
			
			ВидОперации = НСтр("ru = 'Загрузка внешней компоненты из интернет'");
				
			ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки);
			
			ВызватьИсключение ТекстСообщения;
				
		КонецЕсли;

	Иначе
			
		ТекстСообщения = НСтр("ru = 'Не удалось получить информационный файл внешней компоненты.
									|Описание: %1'");
		ТекстОшибки =  НСтр("ru = 'Не удалось получить информационный файл внешней компоненты.
							|Описание: %1
							|URL: %2'");
		Если РезультатИнфоФайл.Свойство("КодСостояния") Тогда
			ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = 'Код ошибки: %2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, РезультатИнфоФайл.СообщениеОбОшибке, РезультатИнфоФайл.КодСостояния);
			ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Код ошибки: %3'");
			ТекстОшибки = СтрШаблон(
				ТекстОшибки, РезультатИнфоФайл.СообщениеОбОшибке, Параметры.URLИнфо, РезультатИнфоФайл.КодСостояния);
		Иначе
			ТекстСообщения = СтрШаблон(ТекстСообщения, РезультатИнфоФайл.СообщениеОбОшибке);
			ТекстОшибки = СтрШаблон(ТекстОшибки, РезультатИнфоФайл.СообщениеОбОшибке, Параметры.URLИнфо);
		КонецЕсли;
		
		ВидОперации = НСтр("ru = 'Загрузка внешней компоненты через интернет'");
		
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки);
		
		ВызватьИсключение ТекстСообщения;
	
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьВременныеФайлы(Путь)
	
	Попытка
		УдалитьФайлы(Путь);
	Исключение
		ВидОперации = НСтр("ru = 'Удаление временного файла.'");
		ПодробныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки);
	КонецПопытки;
	
КонецПроцедуры

Процедура ПолучитьИнформациюОВнешнейКомпоненте(Параметры, Адрес) Экспорт
	
	ВремФайл = ПолучитьИмяВременногоФайла("xml");
	ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
	ПараметрыПолучения.ПутьДляСохранения = ВремФайл;
	ПараметрыПолучения.Таймаут = 30;
	РезультатИнфоФайл = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(Параметры.URLИнфоФайла, ПараметрыПолучения);
	Если РезультатИнфоФайл.Статус Тогда
		ПараметрыВК = ПараметрыВК(ВремФайл);
		УдалитьВременныеФайлы(ВремФайл);
		ПоместитьВоВременноеХранилище(ПараметрыВК, Адрес);
	Иначе
			
		ТекстСообщения = НСтр("ru = 'Не удалось получить информационный файл внешней компоненты.
									|Описание: %1'");
		ТекстОшибки =  НСтр("ru = 'Не удалось получить информационный файл внешней компоненты.
							|Описание: %1
							|URL: %2'");
		Если РезультатИнфоФайл.Свойство("КодСостояния") Тогда
			ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = 'Код ошибки: %2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, РезультатИнфоФайл.СообщениеОбОшибке, РезультатИнфоФайл.КодСостояния);
			ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Код ошибки: %3'");
			ТекстОшибки = СтрШаблон(
				ТекстОшибки, РезультатИнфоФайл.СообщениеОбОшибке, Параметры.URLИнфоФайла, РезультатИнфоФайл.КодСостояния);
		Иначе
			ТекстСообщения = СтрШаблон(ТекстСообщения, РезультатИнфоФайл.СообщениеОбОшибке);
			ТекстОшибки = СтрШаблон(ТекстОшибки, РезультатИнфоФайл.СообщениеОбОшибке, Параметры.URLИнфоФайла);
		КонецЕсли;
		
		ВидОперации = НСтр("ru = 'Загрузка информационного файла через интернет.'");
		
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки);
		
		ВызватьИсключение ТекстСообщения;
	
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбновитьВнешниеКомпоненты(Параметры, Адрес) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВнешниеКомпоненты.Версия,
	               |	ВнешниеКомпоненты.Адрес,
	               |	ВнешниеКомпоненты.Наименование
	               |ИЗ
	               |	Справочник.ДополнительныеВнешниеКомпоненты КАК ВнешниеКомпоненты
	               |ГДЕ
	               |	ИСТИНА";
	
	Если Параметры.Количество() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИСТИНА", "ВнешниеКомпоненты.Идентификатор = &Идентификатор");
		Для Каждого КлючЗначение Из Параметры Цикл
			Запрос.УстановитьПараметр("Идентификатор", КлючЗначение.Ключ);
			Прервать;
		КонецЦикла;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВремФайл = ПолучитьИмяВременногоФайла("xml");
		ПараметрыПолучения = Новый Структура("Таймаут, ПутьДляСохранения", 20, ВремФайл);
		РезультатИнфоФайл = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(Выборка.Адрес, ПараметрыПолучения);
		Если РезультатИнфоФайл.Статус Тогда
			ПараметрыВК = ПараметрыВК(ВремФайл);
			Если Выборка.Версия <> ПараметрыВК.Версия Тогда
				ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
				ПараметрыПолучения.Таймаут = 60;
				РезультатВКФайл = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(
					ПараметрыВК.URLВК, ПараметрыПолучения);
				Если РезультатВКФайл.Статус Тогда
					СохранитьВнешнююКомпонентуВИнформационнойБазе(РезультатВКФайл.Путь);
				Иначе
					ТекстСообщения = НСтр("ru = 'Не удалось скачать файл внешней компоненты: %1
												|Описание: %2'");
					ТекстОшибки =  НСтр("ru = 'Не удалось скачать файл внешней компоненты: %1
											|Описание: %2
											|URL: %3'");
					Если РезультатИнфоФайл.Свойство("КодСостояния") Тогда
						ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = 'Код ошибки: %3'");
						ТекстСообщения = СтрШаблон(
							ТекстСообщения, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, РезультатВКФайл.КодСостояния);
						ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Код ошибки: %4'");
						ТекстОшибки = СтрШаблон(ТекстОшибки, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, ПараметрыВК.URLВК,
							РезультатВКФайл.КодСостояния);
					Иначе
						ТекстСообщения = СтрШаблон(ТекстСообщения, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке);
						ТекстОшибки = СтрШаблон(ТекстОшибки, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, ПараметрыВК.URLВК);
					КонецЕсли;
					
					ВидОперации = НСтр("ru = 'Загрузка внешней компоненты из интернет'");
						
					ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстСообщения);
					
				КонецЕсли;
			КонецЕсли;
		Иначе
			
			ТекстСообщения = НСтр("ru = 'Не удалось получить информацию о файле внешней компоненты: %1
										|Описание: %2'");
			ТекстОшибки =  НСтр("ru = 'Не удалось получить информацию о файле внешней компоненты: %1
								|Описание: %2
								|URL: %3'");
			Если РезультатИнфоФайл.Свойство("КодСостояния") Тогда
				ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = 'Код ошибки: %3'");
				ТекстСообщения = СтрШаблон(
					ТекстСообщения, Выборка.Наименование, РезультатИнфоФайл.СообщениеОбОшибке, РезультатИнфоФайл.КодСостояния);
				ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Код ошибки: %4'");
				ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.Наименование, РезультатИнфоФайл.СообщениеОбОшибке, Выборка.Адрес,
					РезультатИнфоФайл.КодСостояния);
			Иначе
				ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Наименование, РезультатИнфоФайл.СообщениеОбОшибке);
				ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.Наименование, РезультатИнфоФайл.СообщениеОбОшибке, Выборка.Адрес);
			КонецЕсли;
			
			ВидОперации = НСтр("ru = 'Загрузка внешней компоненты из интернет'");
			
			ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстСообщения);
			
		КонецЕсли;
		
		УдалитьФайлы(ВремФайл);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли