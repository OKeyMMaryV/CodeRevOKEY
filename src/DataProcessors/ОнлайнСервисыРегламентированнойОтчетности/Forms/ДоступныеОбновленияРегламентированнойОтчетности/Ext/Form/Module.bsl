﻿&НаКлиенте
Процедура ПерейтиКФормеОбновленияКонфигурации(Команда)
	
	ОткрытьОбработкуОбновленияКонфигурации();
	
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДанные(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЕстьИнформацияОбОбновлениях Тогда
		ПредупреждениеОбОтсутствииИнформации(Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьДанные(Отказ)
	
	ИнформацияОбОбновлениях = ПолучитьИнформациюОбОбновленияхТекущегоРелиза();
	Если ИнформацияОбОбновлениях = Неопределено Тогда
		ЕстьИнформацияОбОбновлениях = Ложь;
		Возврат;
	Иначе
		ЕстьИнформацияОбОбновлениях = Истина;
	КонецЕсли;
	
	ИнформацияОТекущемРелизе = ИнформацияОбОбновлениях.ТекущийРелиз;
	ИнформацияОВнешнихОтчетах = ИнформацияОбОбновлениях.Отчеты;
	ИнформацияОКонфигурациях = ИнформацияОбОбновлениях.Конфигурации;
	
	// заполняем свойства текущего релиза
	ВерсияТекущейПрограммы = СокрЛП(бит_ОбщегоНазначения.МетаданныеВерсия());
	URLТекущейПрограммы = ?(ИнформацияОТекущемРелизе.Свойство("URL"), ИнформацияОТекущемРелизе.URL, Неопределено);
	Если ТипЗнч(URLТекущейПрограммы) = Тип("Строка") Тогда
		URLТекущейПрограммы = СокрЛП(URLТекущейПрограммы);
	КонецЕсли;
	
	// заполняем свойства обновления конфигурации
	Если ИнформацияОКонфигурациях.Количество() > 0 Тогда
		ИнформацияОКонфигурации = ИнформацияОКонфигурациях[0];
		ВерсияОбновленияКонфигурации = СокрЛП(ИнформацияОКонфигурации.Версия);
		ДоступноОбновлениеДо = ВерсияОбновленияКонфигурации;
		Элементы.НадписьПоследняяВерсия.Заголовок = ДоступноОбновлениеДо;
		
		ДополнительнаяИнформацияОбОбновленииПрограммы = СокрЛП(ИнформацияОКонфигурации.ДополнительнаяИнформация);
		Если ЗначениеЗаполнено(ИнформацияОКонфигурации.URL) Тогда
			URLОбновленияПрограммы 						= СокрЛП(ИнформацияОКонфигурации.URL);
			Элементы.НадписьПоследняяВерсия.Подсказка	= СокрЛП(ИнформацияОКонфигурации.URL);
		КонецЕсли;
		Элементы.ПанельДоступноОбновление.ТекущаяСтраница = Элементы.ОбновлениеТребуется;
	Иначе
		Элементы.ПерейтиКФормеОбновленияКонфигурации.Доступность = Ложь;
		URLОбновленияПрограммы = "";
		ДополнительнаяИнформацияОбОбновленииПрограммы = "";
		Элементы.ПанельДоступноОбновление.ТекущаяСтраница = Элементы.ОбновлениеНеТребуется;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(URLОбновленияПрограммы) Тогда
		Элементы.НадписьПоследняяВерсия.Гиперссылка = Ложь;
		Элементы.НадписьПоследняяВерсия.Подсказка = "";
	КонецЕсли;
	
	// отсеиваем неактуальные версии и преобразовываем дерево выпусков внешних отчетов к плоскому списку
	СписокОтчетов = Новый ТаблицаЗначений;
	СписокОтчетов.Колонки.Добавить("ИД");
	СписокОтчетов.Колонки.Добавить("Версия");
	СписокОтчетов.Колонки.Добавить("ДатаВыпуска");
	СписокОтчетов.Колонки.Добавить("ДополнительнаяИнформация");
	СписокОтчетов.Колонки.Добавить("URL");
	СписокОтчетов.Колонки.Добавить("Состав");
	
	ЕдиныйУказательРесурсаПоИД = Новый Соответствие;
	Для Каждого Стр1 Из ИнформацияОВнешнихОтчетах.Строки Цикл
		Для Каждого Стр2 Из Стр1.Строки Цикл
			Если НЕ ЗначениеЗаполнено(Стр2.АктуальнаяВерсия) Тогда
				НовСтр = СписокОтчетов.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр, Стр2);
				Если ЗначениеЗаполнено(Стр2.ИД) Тогда
					ЕдиныйУказательРесурсаПоИД.Вставить(Стр2.ИД, Стр1.URL);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ВозможныеИсточникиОтчета = СписокОтчетов.ВыгрузитьКолонку("ИД");
	
	// делаем запрос к справочнику РегламентированныеОтчеты
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	РегламентированныеОтчеты.Наименование КАК Отчет,
	                      |	РегламентированныеОтчеты.ЭтоГруппа,
	                      |	РегламентированныеОтчеты.ИсточникОтчета
	                      |ИЗ
	                      |	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты
	                      |ГДЕ
	                      |	(РегламентированныеОтчеты.ЭтоГруппа
	                      |			ИЛИ РегламентированныеОтчеты.ИсточникОтчета В (&ИсточникОтчета)
	                      |	) И РегламентированныеОтчеты.ПометкаУдаления = &ПометкаУдаления
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	РегламентированныеОтчеты.Код ИЕРАРХИЯ");
	
	Запрос.УстановитьПараметр("ИсточникОтчета", ВозможныеИсточникиОтчета);
	Запрос.УстановитьПараметр("НеПоказыватьВСписке", Ложь);
	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	
	// выгружаем дерево-результат
	
	ДеревоОтчетов = РеквизитФормыВЗначение("Дерево"); 
	ДеревоОтчетов = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ДеревоОтчетов.Колонки.Добавить("URL");
	
	// добавляем к дереву отчеты с теми ИД, по которым были выпуски, но их нет в справочнике
	Для Каждого СтрСписокОтчетов Из СписокОтчетов Цикл
		Если ДеревоОтчетов.Строки.Найти(СокрЛП(СтрСписокОтчетов.ИД), "ИсточникОтчета", Истина) = Неопределено Тогда
			НовСтр = ДеревоОтчетов.Строки.Добавить();
			НовСтр.ИсточникОтчета = СокрЛП(СтрСписокОтчетов.ИД);
			НовСтр.ЭтоГруппа = Ложь;
			НовСтр.Отчет = СтрСписокОтчетов.Состав;
		КонецЕсли;
	КонецЦикла;
	
	// очищаем от пустых групп
	ОбщееКоличество = ДеревоОтчетов.Строки.Количество();
	Для ОбрИнд = 1 По ОбщееКоличество Цикл
		Инд = ОбщееКоличество - ОбрИнд;
		ТекСтр = ДеревоОтчетов.Строки[Инд];
		Если ТекСтр.ЭтоГруппа И ТекСтр.Строки.Количество() = 0 Тогда
			ДеревоОтчетов.Строки.Удалить(ТекСтр);
		КонецЕсли;
	КонецЦикла;
	
	// инициализируем интернет-адреса
	Для Каждого Стр1 Из ДеревоОтчетов.Строки Цикл
		Если НЕ Стр1.ЭтоГруппа Тогда
			URL = ЕдиныйУказательРесурсаПоИД[Стр1.ИсточникОтчета];
			Если ЗначениеЗаполнено(URL) Тогда
				Стр1.URL = URL;
			КонецЕсли;
		Иначе
			Для Каждого Стр2 Из Стр1.Строки Цикл
				URL = ЕдиныйУказательРесурсаПоИД[Стр2.ИсточникОтчета];
				Если ЗначениеЗаполнено(URL) Тогда
					Стр2.URL = URL;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	// регулируем показ списка отчетов
	Если ДеревоОтчетов.Строки.Количество() = 0 Тогда
		Элементы.ПанельСписокОтчетов.ТекущаяСтраница = Элементы.СписокВнешнихОтчетовПуст;
	Иначе
		Элементы.ПанельСписокОтчетов.ТекущаяСтраница = Элементы.СписокВнешнихОтчетов;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДеревоОтчетов, "Дерево");
	
	// регулируем показ ссылок
	Элементы.НадписьОткрытьWebСтраницу.Видимость = ЗначениеЗаполнено(URLТекущейПрограммы);
	Элементы.НадписьОткрытьWebСтраницу.Подсказка = URLТекущейПрограммы;
	Элементы.НадписьОткрытьДополнительнуюИнформацию.Видимость = ЗначениеЗаполнено(ДополнительнаяИнформацияОбОбновленииПрограммы);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИнформациюОбОбновленияхТекущегоРелиза() Экспорт
	
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.МеханизмОнлайнСервисовВключен() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПолучитьДанныеМеханизмаОнлайнСервисовРО(Перечисления.ТипыРесурсовМеханизмаОнлайнСервисовРО.ИнформацияОРелизе);
	Если НЕ ЗначениеЗаполнено(Результат) ИЛИ Результат.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеТекущегоРелиза = Результат[0].Данные;
	Если НЕ ЗначениеЗаполнено(ДанныеТекущегоРелиза) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДеревоИнформацииТекущегоРелиза = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ЗагрузитьСтрокуXMLВДеревоЗначений(ДанныеТекущегоРелиза);
	Если НЕ ЗначениеЗаполнено(ДеревоИнформацииТекущегоРелиза) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// проверяем, "понятная" ли редакция у справочной информации
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.РедакцияФорматаСправочнойИнформацииПрименима(ДеревоИнформацииТекущегоРелиза) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// проверяем, точно ли для текущего релиза информация
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ИнформацияОРелизеСоответствуетТекущейПрограмме(ДеревоИнформацииТекущегоРелиза) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураРезультат = Новый Структура;
	
	ТекущийРелиз = Новый Структура;
	
	ПолноеДеревоДополнительныеОтчеты = Новый ДеревоЗначений;
	ПолноеДеревоДополнительныеОтчеты.Колонки.Добавить("Версия");
	ПолноеДеревоДополнительныеОтчеты.Колонки.Добавить("Состав");
	ПолноеДеревоДополнительныеОтчеты.Колонки.Добавить("ДополнительнаяИнформация");
	ПолноеДеревоДополнительныеОтчеты.Колонки.Добавить("URL");
	ПолноеДеревоДополнительныеОтчеты.Колонки.Добавить("ДатаВыпуска");
	ПолноеДеревоДополнительныеОтчеты.Колонки.Добавить("ИД");
	ПолноеДеревоДополнительныеОтчеты.Колонки.Добавить("АктуальнаяВерсия");
	ПолноеДеревоДополнительныеОтчеты.Колонки.Добавить("Порядок");
	
	ПолнаяТаблицаКонфигураций = Новый ТаблицаЗначений;
	ПолнаяТаблицаКонфигураций.Колонки.Добавить("Версия");
	ПолнаяТаблицаКонфигураций.Колонки.Добавить("ДополнительнаяИнформация");
	ПолнаяТаблицаКонфигураций.Колонки.Добавить("URL");
	ПолнаяТаблицаКонфигураций.Колонки.Добавить("ДатаВыпуска");
	
	УзелФайл = ДеревоИнформацииТекущегоРелиза.Строки.Найти("Файл", "Имя");
	Если УзелФайл <> Неопределено Тогда
		УзлыРелиз = УзелФайл.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "Рлз", "Э"));
		Если УзлыРелиз.Количество() > 0 Тогда
			УзелРелиз = УзлыРелиз[0];
			Если ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ФайлИнформацииОРелизеСоответствуетТекущейПрограмме(УзелРелиз) Тогда
				
				// заполняем свойства текущего релиза
				АтрибутыУзла = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПолучитьАтрибутыУзла(УзелРелиз);
				Если АтрибутыУзла.Свойство("Верс") Тогда
					ТекущийРелиз.Вставить("Версия", СокрЛП(АтрибутыУзла.Верс));
				КонецЕсли;
				Если АтрибутыУзла.Свойство("Платф") Тогда
					ТекущийРелиз.Вставить("Платформа", СокрЛП(АтрибутыУзла.Платф));
				КонецЕсли;
				Если АтрибутыУзла.Свойство("ИД") Тогда
					ТекущийРелиз.Вставить("ИД", СокрЛП(АтрибутыУзла.ИД));
				КонецЕсли;
				Если АтрибутыУзла.Свойство("URL") Тогда
					ТекущийРелиз.Вставить("URL", СокрЛП(АтрибутыУзла.URL));
				КонецЕсли;
				
				// заполняем дерево внешних отчетов
				УзлыДочерниеВыпуски = УзелРелиз.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "ДочВып", "Э"));
				Если УзлыДочерниеВыпуски.Количество() > 0 Тогда
					УзелДочерниеВыпуски = УзлыДочерниеВыпуски[0];
					УзлыВыпуск = УзелДочерниеВыпуски.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "Вып", "Э"));
					Для Каждого УзелВыпуск Из УзлыВыпуск Цикл
						АтрибутыУзла = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПолучитьАтрибутыУзла(УзелВыпуск);
						СтрВыпуск = ПолноеДеревоДополнительныеОтчеты.Строки.Добавить();
						СтрВыпуск.Версия = АтрибутыУзла.Верс;
						Если АтрибутыУзла.Свойство("ПричиныВыпуска") Тогда
							СтрВыпуск.ДополнительнаяИнформация = АтрибутыУзла.ДопИнф;
						КонецЕсли;
						Если АтрибутыУзла.Свойство("URL") Тогда
							СтрВыпуск.URL = АтрибутыУзла.URL;
						КонецЕсли;
						Если АтрибутыУзла.Свойство("ДатаВ") Тогда
							СтрВыпуск.ДатаВыпуска = XMLЗначение(Тип("Дата"), АтрибутыУзла.ДатаВ);
						КонецЕсли;
						СтрВыпуск.Порядок = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПорядокПоНомеруВерсии(СтрВыпуск.Версия);
						УзлыОбъекты = УзелВыпуск.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "Обкты", "Э"));
						Если УзлыОбъекты.Количество() > 0 Тогда
							УзелОбъекты = УзлыОбъекты[0];
							УзлыОбъект = УзелОбъекты.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "Обкт", "Э"));
							Для Каждого УзелОбъект Из УзлыОбъект Цикл
								АтрибутыУзлаОбъект = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПолучитьАтрибутыУзла(УзелОбъект);
								Если АтрибутыУзлаОбъект.Свойство("Предст") Тогда
									СтрОбъект = СтрВыпуск.Строки.Добавить();
									СтрОбъект.Версия = АтрибутыУзла.Верс;
									СтрОбъект.Состав = АтрибутыУзлаОбъект.Предст;
									Если АтрибутыУзлаОбъект.Свойство("ИД") Тогда
										СтрОбъект.ИД = АтрибутыУзлаОбъект.ИД;
									КонецЕсли;
								ИначеЕсли АтрибутыУзлаОбъект.Свойство("ИД") Тогда
									СтрОбъект = СтрВыпуск.Строки.Добавить();
									СтрОбъект.Версия = АтрибутыУзла.Верс;
									СтрОбъект.ИД = АтрибутыУзлаОбъект.ИД;
									СтрОбъект.Представление = АтрибутыУзлаОбъект.ИД;
								КонецЕсли;
							КонецЦикла;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
				// заполняем дерево обновлений конфигурации
				УзлыРелизыОбновления = УзелРелиз.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "Обнов", "Э"));
				Если УзлыРелизыОбновления.Количество() > 0 Тогда
					УзелРелизыОбновления = УзлыРелизыОбновления[0];
					УзлыРелизОбновление = УзелРелизыОбновления.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "Рлз", "Э"));
					Для Каждого УзелРелизОбновление Из УзлыРелизОбновление Цикл
						АтрибутыУзла = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПолучитьАтрибутыУзла(УзелРелизОбновление);
						НовСтр = ПолнаяТаблицаКонфигураций.Добавить();
						НовСтр.Версия = АтрибутыУзла.Верс;
						Если АтрибутыУзла.Свойство("ДопИнф") Тогда
							НовСтр.ДополнительнаяИнформация = АтрибутыУзла.ДопИнф;
						КонецЕсли;
						Если АтрибутыУзла.Свойство("URL") Тогда
							НовСтр.URL = АтрибутыУзла.URL;
						КонецЕсли;
						Если АтрибутыУзла.Свойство("ДатаВ") Тогда
							НовСтр.ДатаВыпуска = XMLЗначение(Тип("Дата"), АтрибутыУзла.ДатаВ);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ПолноеДеревоДополнительныеОтчеты.Строки.Сортировать("Порядок");
	ПолнаяТаблицаКонфигураций.Сортировать("ДатаВыпуска");
	
	// заполняем признак "АктуальнаяВерсия" у внешних отчетов
	Для Каждого Стр1 Из ПолноеДеревоДополнительныеОтчеты.Строки Цикл
		Для Каждого Стр2 Из Стр1.Строки Цикл
			Если ЗначениеЗаполнено(Стр2.ИД) Тогда
				СтрАктуальныйОтчет = Неопределено;
				РезультатПоискаАналогичныхОтчетов = ПолноеДеревоДополнительныеОтчеты.Строки.НайтиСтроки(Новый Структура("ИД", Стр2.ИД), Истина);
				Для Каждого Результат Из РезультатПоискаАналогичныхОтчетов Цикл
					Если Результат.Уровень() = 1 И ЗначениеЗаполнено(Результат.Родитель.Порядок) И Результат.Родитель.Порядок > Стр1.Порядок Тогда
						Если СтрАктуальныйОтчет = Неопределено ИЛИ СтрАктуальныйОтчет.Порядок < Результат.Родитель.Порядок Тогда
							Стр2.АктуальнаяВерсия = Результат.Родитель.Версия;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// если все результирующие структуры пусты, то вернем Неопределено
	Если ТекущийРелиз.Количество() = 0 И ПолноеДеревоДополнительныеОтчеты.Строки.Количество() = 0 И ПолнаяТаблицаКонфигураций.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураРезультат.Вставить("ТекущийРелиз", ТекущийРелиз);
	СтруктураРезультат.Вставить("Отчеты", ПолноеДеревоДополнительныеОтчеты);
	СтруктураРезультат.Вставить("Конфигурации", ПолнаяТаблицаКонфигураций);
	
	Возврат СтруктураРезультат;
	
КонецФункции

&НаКлиенте
Процедура ПредупреждениеОбОтсутствииИнформации(Отказ)
	
	ПоказатьПредупреждение(, "Информация об обновлениях отсутствует.");
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОткрытьДополнительнуюИнформациюНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДополнительнаяИнформация", ДополнительнаяИнформацияОбОбновленииПрограммы);
	
	ОткрытьФорму("Обработка.ОнлайнСервисыРегламентированнойОтчетности.Форма.ДополнительнаяИнформацияОВыпуске", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПоследняяВерсияНажатие(Элемент)
	
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(URLОбновленияПрограммы);

КонецПроцедуры

&НаКлиенте
Процедура НадписьОткрытьWebСтраницуНажатие(Элемент)
	
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(URLТекущейПрограммы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбработкуОбновленияКонфигурации()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьОбработкуОбновленияКонфигурацииЗавершение", ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения, "Текущая форма будет закрыта. Продолжить?", РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбработкуОбновленияКонфигурацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПолучениеОбновленийПрограммыКлиент.ОбновитьПрограмму();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтчетовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтчетовПриАктивизацииСтроки(Элемент)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		Если НЕ Элемент.ТекущиеДанные.ЭтоГруппа Тогда
			
			ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(Элемент.ТекущиеДанные.URL);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//мОткрытьФормуОбновленияКонфигурацииКонфигурации = Ложь;
ЦветГиперссылки = Новый Цвет(0, 0, 128);