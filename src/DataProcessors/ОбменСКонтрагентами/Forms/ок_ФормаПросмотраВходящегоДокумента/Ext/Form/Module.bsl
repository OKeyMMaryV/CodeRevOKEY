﻿//ОКЕЙ Вдовиченко Г.В(СофтЛаб) 2019-05-13 (#3340)

&НаКлиенте
Перем СкрываемыеКоманды;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Документ = Параметры.Ключ;
	ИначеЕсли Параметры.Свойство("Документ") Тогда
		Документ = Параметры.Документ;
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-21 (#3997)
	Если НЕ ЗначениеЗаполнено(Документ) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнен документ");
		Отказ = Истина;
		Возврат;	
	КонецЕсли;
	
	Если РольДоступна("ПолныеПрава") ИЛИ РольДоступна("ДобавлениеИзменениеЭлектронныхДокументов") Тогда
		БухгалтерИлиПолныеПрава = Истина;
	Иначе
		ИзменитьФормуПоОграничениям();
	КонецЕсли;	
		
	Результат = ПолучитьДоступностьФормы();
	
	Если Не Результат.Пустой() Тогда
		Элементы.ГруппаКнопокСогласования.Видимость = Истина;
		
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-05-14 (#4117)
		Если Документ.ок_Статус = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.НаСогласование") Тогда
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-05-14 (#4117)
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			Если Не ЗначениеЗаполнено(Выборка.Решение) Тогда
				Элементы.Согласовать.Доступность = Истина;
				Элементы.НеСогласовывать.Доступность = Истина;	
			КонецЕсли;
			
			Элементы.ок_НомерЗаякиРедактируемая.Видимость = Выборка.ок_ТребуетсяЗаявка1С И Выборка.ОтветственныйЗаНомерЗаявки И НЕ ЗначениеЗаполнено(Выборка.ок_НомерЗаявки);
			Элементы.Документок_НомерЗаявки.Видимость = НЕ Элементы.ок_НомерЗаякиРедактируемая.Видимость; 
			
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-05-14 (#4117)
		КонецЕсли;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-05-14 (#4117)
		
	ИначеЕсли Не РольДоступна("ПолныеПрава") И Не РольДоступна("ДобавлениеИзменениеЭлектронныхДокументов") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("У вас нет прав на просмотр данного документа");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-21 (#3997) 
			
	Заголовок = "" + Документ;
	ЗаполнитьФайлы();
	ЗаполнитьИсториюПереписки();
	Если ЗначениеЗаполнено(Документ) Тогда
		
		МассивДокументов = МассивДокументовУчета(Документ);
		Если МассивДокументов.Количество() > 0 Тогда 
			ДокументУчета = МассивДокументов[0];
		КонецЕсли;	
	
	КонецЕсли;	
	
	ВывестиДокументыУчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановленаПрограммаОтображенияПредставленияHTML = ок_УправлениеФормамиКлиент.УстановленаПрограммаОтображенияПредставленияHTML();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ок_ОбменСКонтрагентамиКлиент.ОчиститьВременныйФайл(ИмяВременногоФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ВывестиДокументыУчета();
	
КонецПроцедуры


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьПредставление(Команда)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ТабличныйДокумент = ок_ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьТабличныйДокументФайлаЭД(ТекущиеДанные.ПрисоединенныйФайл, УникальныйИдентификатор);
	Если ТабличныйДокумент = Неопределено Тогда
		ПоказатьПредупреждение(, "Не удалось сформировать представление");
		Возврат;
	КонецЕсли;	
		
	ТабличныйДокумент.Показать("Представление " + ТекущиеДанные.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КарточкаДокумента(Команда)
	
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Возврат;
	КонецЕсли;	
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-02-09 (#3997)
	Реквизиты = ОК_ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Документ, "ИдентификаторОрганизации");
	Если НЕ ЗначениеЗаполнено(Реквизиты.ИдентификаторОрганизации) Тогда
	    ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.ок_ФормаВходящегоБумажногоДокумента", Новый Структура("Ключ", Документ));	
	Иначе
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-02-09 (#3997) 	
		ОткрытьФорму("Документ.ЭлектронныйДокументВходящий.Форма.ФормаДокумента", Новый Структура("Ключ", Документ));
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-02-09 (#3997) 	
	КонецЕсли; 
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-02-09 (#3997) 
	
КонецПроцедуры

&НаКлиенте
Процедура ТиповаяФормаПросмотра(Команда)
	
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Возврат;
	КонецЕсли;	
	
	ОткрытьФорму("Документ.ЭлектронныйДокументВходящий.Форма.ФормаПросмотраЭД", Новый Структура("Ключ", Документ));
	//Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналCобытийЭДО(Команда)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ПрисоединенныйФайл", ТекущиеДанные.ПрисоединенныйФайл);
	
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ОткрытьФорму("РегистрСведений.ЖурналСобытийЭД.ФормаСписка", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-21 (#3997) 
&НаКлиенте
Процедура Согласовать(Команда)
	
	Если Элементы.ок_НомерЗаякиРедактируемая.Видимость И НЕ ЗначениеЗаполнено(ок_НомерЗаякиРедактируемая) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Требуется ввести номер заявки",,"ок_НомерЗаякиРедактируемая");
	Иначе	
		ок_ОбменСКонтрагентамиКлиент.УстановитьРешение(ЭтаФорма, ПредопределенноеЗначение("Справочник.бит_ВидыРешенийСогласования.Согласовано"), ок_НомерЗаякиРедактируемая);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеСогласовывать(Команда)
	ок_ОбменСКонтрагентамиКлиент.УстановитьРешение(ЭтаФорма, ПредопределенноеЗначение("Справочник.бит_ВидыРешенийСогласования.Отклонено"));	
КонецПроцедуры
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-21 (#3997)

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ФайлыПрисоединенныйФайлНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеСтроки = Элементы.Файлы.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ДанныеФайлаВложения(Неопределено, ДанныеСтроки.ПрисоединенныйФайл, УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	//Если Элемент.ТекущийЭлемент.Имя = "ФайлыИмя" Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеСтроки = Файлы.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ДанныеСтроки <> Неопределено Тогда
			ДанныеФайла = ДанныеФайлаВложения(Неопределено, ДанныеСтроки.ПрисоединенныйФайл, УникальныйИдентификатор);
			РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
		КонецЕсли;
	//КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПриАктивизацииСтроки(Элемент)
	
	ДоступныеЭлементы = Новый Массив;
	
	ПрисоединенныйФайл = Неопределено;
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Расширение = "";
	Если ТекущиеДанные <> Неопределено Тогда
		//Если НРег(ТекущиеДанные.Расширение) = "xml" 
		//	ИЛИ НРег(ТекущиеДанные.Расширение) = "pdf" Тогда
			//ДоступныеЭлементы.Добавить("ФайлыПоказатьПредставление");
		//КонецЕсли;	
		ПрисоединенныйФайл = ТекущиеДанные.ПрисоединенныйФайл;
		Расширение = ТекущиеДанные.Расширение;
		
		//ОКЕЙ Вдовиченко Г.В(СофтЛаб) Начало 2019-07-10 (#3394)
		ПрисоединенныйФайлСсылка = ТекущиеДанные.ПрисоединенныйФайл;
		//ОКЕЙ Вдовиченко Г.В(СофтЛаб) Конец 2019-07-10 (#3394)
		
	КонецЕсли;
	
	Для каждого Имя из СкрываемыеКоманды Цикл
		Элемент = Элементы.Найти(Имя);
		Если Элемент = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Элемент.Видимость = (ДоступныеЭлементы.Найти(Имя) <> Неопределено);
	КонецЦикла;	
	
	Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяСтраницы = "СтраницаПредставлениеПустая";
	Если Расширение = "pdf" Тогда
		Если УстановленаПрограммаОтображенияПредставленияHTML Тогда
			ПредставлениеФайлаHTML = "";
			Данные = ПолучитьИзВременногоХранилища(ок_ОбменСКонтрагентамиСлужебныйВызовСервера.АдресДанныхПрисоединенныйФайл(ПрисоединенныйФайл, УникальныйИдентификатор));
			Если ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
				ок_ОбменСКонтрагентамиКлиент.ОчиститьВременныйФайл(ИмяВременногоФайла);
				ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
				Данные.Записать(ИмяВременногоФайла);
				ПредставлениеФайлаHTML = ок_ОбменСКонтрагентамиКлиент.HTMLПредставлениеФайлаЭД(ИмяВременногоФайла, Расширение);
			КонецЕсли;	
			Если Не ПустаяСтрока(ПредставлениеФайлаHTML) Тогда
				ИмяСтраницы = "СтраницаПредставлениеHTML";
			КонецЕсли;	
		КонецЕсли;
	ИначеЕсли Расширение = "xml" Тогда
		УстановитьВидимость = Ложь;
		ОтобразитьПредставление(ПрисоединенныйФайл, УстановитьВидимость);
		Если УстановитьВидимость Тогда
			ИмяСтраницы = "СтраницаПредставление";
		КонецЕсли;	
	КонецЕсли;	
	
	Элементы.СтраницыПредставления.ТекущаяСтраница = Элементы.Найти(ИмяСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВсеФайлыПриИзменении(Элемент)
	
	ЗаполнитьФайлы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстДокументИБОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "ТекстДокументИБНажатие" Тогда
		СтандартнаяОбработка = Ложь;
		ТекстДокументИБНажатие();
	ИначеЕсли НавигационнаяСсылка = "ОткрытьФормуПодбора" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуПодбора();
	КонецЕсли;
	
КонецПроцедуры

//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-05-19 (#3732)
&НаКлиенте
Процедура ИсторияПерепискиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ИсторияПерепискиКомментарий" Тогда
	
		ДанныеВыбраннойСтроки = ИсторияПереписки.Получить(ВыбраннаяСтрока);
		ОткрытьЗначение(ДанныеВыбраннойСтроки.Комментарий);
	
	КонецЕсли;
	
КонецПроцедуры
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-05-19 (#3732)

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФайлы()
	
	Файлы.Очистить();
	Если ЗначениеЗаполнено(Документ) Тогда
		
		Данные = ок_ОбменСКонтрагентамиВнутренний.ПолучитьПрисоединенныеФайлыВходящегоЭДДляОтображения(Документ, ОтображатьВсеФайлы);
		Если Данные <> Неопределено Тогда
			Файлы.Загрузить(Данные);
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИсториюПереписки()
	
	ИсторияПереписки.Очистить();
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-21 (#3997)
	Если НЕ БухгалтерИлиПолныеПрава Тогда		
		Данные = РегистрыСведений.ок_ИсторияПерепискиСогласованияЭД.ПолучитьИсториюПерепискиДокументаПоПользователю(Документ, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"));
	Иначе
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-21 (#3997) 
		Данные = РегистрыСведений.ок_ИсторияПерепискиСогласованияЭД.ПолучитьИсториюПерепискиДокумента(Документ);	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-21 (#3997)
	КонецЕсли;	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-21 (#3997) 
		
	Если Данные <> Неопределено Тогда
		ИсторияПереписки.Загрузить(Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеФайлаВложения(АдресВременногоХранилищаВложения, ПрисоединенныйФайлСсылка, УникальныйИдентификатор)
	
	ДанныеФайла = Неопределено;
	Если ЭтоАдресВременногоХранилища(АдресВременногоХранилищаВложения) Тогда
		// Файл во временном хранилище
		ДанныеФайла = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаВложения);
		ДанныеФайла.Вставить("Ссылка", Неопределено);
	ИначеЕсли ЗначениеЗаполнено(ПрисоединенныйФайлСсылка) Тогда
		// Файл записан в ИБ
		ДанныеФайла = ОбменСКонтрагентамиСлужебный.ПолучитьДанныеФайла(ПрисоединенныйФайлСсылка, УникальныйИдентификатор);
		ДанныеФайла.Вставить("Ссылка", ПрисоединенныйФайлСсылка);
	КонецЕсли;
	
	Возврат ДанныеФайла;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеHTML(ПрисоединенныйФайл, Расширение)
	
	Возврат ок_ОбменСКонтрагентамиВнутренний.HTMLПредставлениеФайлаЭД(ПрисоединенныйФайл, Расширение);
		
КонецФункции

&НаСервере
Процедура ОтобразитьПредставление(ПрисоединенныйФайл, УстановитьВидимость = Ложь)
	
	ТабличныйДокумент = ок_ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьТабличныйДокументФайлаЭД(ПрисоединенныйФайл, УникальныйИдентификатор);
	Если ТабличныйДокумент <> Неопределено Тогда
		ПредставлениеФайла.Очистить();
		ПредставлениеФайла.Вывести(ТабличныйДокумент);
		УстановитьВидимость = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбора()
	
	ПараметрыФормы = Новый Структура("ЭлектронныйДокумент", Документ);
	ОткрытьФорму("Документ.ЭлектронныйДокументВходящий.Форма.ПодборДокументовУчета", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстДокументИБНажатие()
		
	МассивДокументов = МассивДокументовУчета(Документ);
		
	Если МассивДокументов.Количество() = 1 Тогда
		
		ПоказатьЗначение( ,МассивДокументов[0]);
			
	Иначе
		
		ОткрытьФормуПодбора();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МассивДокументовУчета(ЭлектронныйДокумент)
	
	//ОКЕЙ Вдовиченко Г.В(СофтЛаб) Начало 2019-08-05 (#3364)
	Возврат ок_ОбменСКонтрагентамиВнутренний.МассивДокументовУчетаВходящегоЭД(ЭлектронныйДокумент);
	//ОКЕЙ Вдовиченко Г.В(СофтЛаб) Конец 2019-08-05 (#3364)
	
	Возврат ЭлектронныйДокумент.ДокументыОснования.Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	
КонецФункции

&НаСервере
Процедура ВывестиДокументыУчета()
	
	МассивДокументов = МассивДокументовУчета(Документ);
	КоличествоДокументов = МассивДокументов.Количество();
	
	Элементы.ТекстДокументИБ.Заголовок = НСтр("ru = 'Документ учета'");
	ОтображатьПодбор = Ложь;
	
	Если КоличествоДокументов = 0 Тогда
		
		ПредставлениеДокументов = НСтр("ru = 'Отразить в учете'");
		
	ИначеЕсли КоличествоДокументов >= 1  Тогда
		
		ПредставлениеДокументов = Строка(МассивДокументов[0]);			
		ОтображатьПодбор = Истина;
			
	//Иначе
	//	
	//	Элементы.ТекстДокументИБ.Заголовок = НСтр("ru = 'Документы учета'");
	//	ШаблонТекста = НСтр("ru = 'Список документов (%1)'");
	//	ПредставлениеДокументов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста,КоличествоДокументов);
	КонецЕсли;
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
		ПредставлениеДокументов, , , , "ТекстДокументИБНажатие"));
	
	Если ОтображатьПодбор Тогда
		МассивСтрок.Добавить("   ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = '<Подбор>'"), ,
			, ,
			"ОткрытьФормуПодбора"));
	КонецЕсли;
	
	ТекстДокументИБ = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-21 (#3997)
&НаСервере
Процедура ИзменитьФормуПоОграничениям()
	
	Элементы.ГруппаКнопокСогласования.Видимость = Истина;
	Элементы.СтраницаИнформация.Видимость = Ложь;
	Элементы.ФайлыКарточкаДокумента.Видимость = Ложь;
	Элементы.ФайлыТиповаяФормаПросмотра.Видимость = Ложь;
	Элементы.Переместить(Элементы.Документок_НомерЗаявки, Элементы.ГруппаЛево);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДоступностьФормы() 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	 "ВЫБРАТЬ РАЗЛИЧНЫЕ
	 |	бит_НазначенныеЗаместители.Состояние КАК Состояние,
	 |	ВЫБОР
	 |		КОГДА бит_НазначенныеЗаместители.Виза ССЫЛКА Справочник.бит_Визы
	 |			ТОГДА бит_НазначенныеЗаместители.Виза
	 |		ИНАЧЕ бит_ГруппыВизВизыГруппы.Виза
	 |	КОНЕЦ КАК Виза,
	 |	бит_НазначенныеЗаместители.Заместитель КАК Заместитель,
	 |	бит_НазначенныеЗаместители.ДатаНачала КАК ДатаНачала,
	 |	бит_НазначенныеЗаместители.ДатаОкончания КАК ДатаОкончания,
	 |	бит_НазначенныеЗаместители.Пользователь КАК Пользователь,
	 |	бит_БК_Инициаторы.Ссылка КАК Инициатор
	 |ПОМЕСТИТЬ ВТ_ЗаместителиИВизы
	 |ИЗ
	 |	РегистрСведений.бит_НазначенныеЗаместители КАК бит_НазначенныеЗаместители
	 |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.бит_ГруппыВиз.ВизыГруппы КАК бит_ГруппыВизВизыГруппы
	 |		ПО бит_НазначенныеЗаместители.Виза = бит_ГруппыВизВизыГруппы.Ссылка
	 |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.бит_БК_Инициаторы КАК бит_БК_Инициаторы
	 |		ПО бит_НазначенныеЗаместители.Заместитель = бит_БК_Инициаторы.Пользователь
	 |ГДЕ
	 |	бит_НазначенныеЗаместители.Состояние = ЗНАЧЕНИЕ(Перечисление.бит_СостоянияЗаместителей.Назначен)
	 |	И бит_НазначенныеЗаместители.ДатаНачала <> ДАТАВРЕМЯ(1, 1, 1)
	 |	И бит_НазначенныеЗаместители.ДатаНачала <= &ТекущаяДата
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	ЭлектронныйДокументВходящийок_Инициаторы.Инициатор КАК Инициатор,
	 |	ЭлектронныйДокументВходящийок_Инициаторы.ОтветственныйЗаНомерЗаявки КАК ОтветственныйЗаНомерЗаявки,
	 |	ЭлектронныйДокументВходящийок_Инициаторы.Ссылка.ок_НомерЗаявки КАК ок_НомерЗаявки,
	 //ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-24 (#4054)
	 |	ЭлектронныйДокументВходящийок_Инициаторы.ИД КАК ИД,
	 //ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-24 (#4054) 
	 |	ЭлектронныйДокументВходящийок_Инициаторы.Ссылка.ок_ТребуетсяЗаявка1С КАК ок_ТребуетсяЗаявка1С
	 |ПОМЕСТИТЬ ВТ_ТЧ_Инициаторы
	 |ИЗ
	 |	Документ.ЭлектронныйДокументВходящий.ок_Инициаторы КАК ЭлектронныйДокументВходящийок_Инициаторы
	 |ГДЕ
	 |	ЭлектронныйДокументВходящийок_Инициаторы.Ссылка = &Документ
	 //ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-24 (#4054)
	 //|	И ЭлектронныйДокументВходящийок_Инициаторы.Инициатор = &Инициатор
	 //ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-24 (#4054) 	 
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	бит_УстановленныеВизы.Объект КАК ОбъектВизирования,
	 |	бит_УстановленныеВизы.Виза КАК Виза,
	 |	бит_УстановленныеВизы.ФизическоеЛицо КАК ФизическоеЛицо,
	 |	бит_УстановленныеВизы.Пользователь КАК Пользователь,
	 |	бит_УстановленныеВизы.ФизическоеЛицо.Пользователь КАК ФизическоеЛицоПользователь,
	 |	бит_УстановленныеВизы.Решение КАК Решение,
	 |	ЕСТЬNULL(ВТ_ТЧ_Инициаторы.ОтветственныйЗаНомерЗаявки, ЛОЖЬ) КАК ОтветственныйЗаНомерЗаявки,
	 |	ВТ_ТЧ_Инициаторы.ок_НомерЗаявки КАК ок_НомерЗаявки,
	 |	ЕСТЬNULL(ВТ_ТЧ_Инициаторы.ок_ТребуетсяЗаявка1С, ЛОЖЬ) КАК ок_ТребуетсяЗаявка1С
	 |ПОМЕСТИТЬ ВТ_УстановленныеВизы
	 |ИЗ
	 |	РегистрСведений.бит_УстановленныеВизы КАК бит_УстановленныеВизы
	 |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТЧ_Инициаторы КАК ВТ_ТЧ_Инициаторы
	 //ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-24 (#4054)
	 //|		ПО бит_УстановленныеВизы.ФизическоеЛицо = ВТ_ТЧ_Инициаторы.Инициатор
	 |		ПО бит_УстановленныеВизы.ИД = ВТ_ТЧ_Инициаторы.ИД
	 //ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-24 (#4054) 	 
	 |ГДЕ
	 |	бит_УстановленныеВизы.Объект = &Документ
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	ВТ_УстановленныеВизы.Решение КАК Решение,
	 |	ВТ_УстановленныеВизы.ОтветственныйЗаНомерЗаявки КАК ОтветственныйЗаНомерЗаявки,
	 |	ВТ_УстановленныеВизы.ок_НомерЗаявки КАК ок_НомерЗаявки,
	 |	ВТ_УстановленныеВизы.ок_ТребуетсяЗаявка1С КАК ок_ТребуетсяЗаявка1С
	 |ИЗ
	 |	ВТ_УстановленныеВизы КАК ВТ_УстановленныеВизы
	 |ГДЕ
	 |	(ВТ_УстановленныеВизы.ФизическоеЛицо = &Инициатор
	 |			ИЛИ ВТ_УстановленныеВизы.Пользователь = &Пользователь)
	 |
	 |ОБЪЕДИНИТЬ
	 |
	 |ВЫБРАТЬ РАЗЛИЧНЫЕ
	 |	ВТ_УстановленныеВизы.Решение,
	 |	ВТ_УстановленныеВизы.ОтветственныйЗаНомерЗаявки,
	 |	ВТ_УстановленныеВизы.ок_НомерЗаявки,
	 |	ВТ_УстановленныеВизы.ок_ТребуетсяЗаявка1С
	 |ИЗ
	 |	ВТ_УстановленныеВизы КАК ВТ_УстановленныеВизы
	 |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЗаместителиИВизы КАК ВТ_ЗаместителиИВизы
	 |		ПО ВТ_УстановленныеВизы.Виза = ВТ_ЗаместителиИВизы.Виза
	 |			И ВТ_УстановленныеВизы.ФизическоеЛицоПользователь = ВТ_ЗаместителиИВизы.Пользователь
	 |ГДЕ
	 |	(ВТ_ЗаместителиИВизы.Инициатор = &Инициатор
	 |			ИЛИ ВТ_ЗаместителиИВизы.Заместитель = &Пользователь)
	 |
	 |ОБЪЕДИНИТЬ
	 |
	 |ВЫБРАТЬ РАЗЛИЧНЫЕ
	 |	ВТ_УстановленныеВизы.Решение,
	 |	ВТ_УстановленныеВизы.ОтветственныйЗаНомерЗаявки,
	 |	ВТ_УстановленныеВизы.ок_НомерЗаявки,
	 |	ВТ_УстановленныеВизы.ок_ТребуетсяЗаявка1С
	 |ИЗ
	 |	ВТ_УстановленныеВизы КАК ВТ_УстановленныеВизы
	 |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ЗаместителиИВизы КАК ВТ_ЗаместителиИВизы
	 |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ЗаместителиИВизы КАК ВТ_ЗаместителиЗаместителей
	 |			ПО (ВТ_ЗаместителиЗаместителей.Виза = ВТ_ЗаместителиИВизы.Виза)
	 |				И (ВТ_ЗаместителиЗаместителей.Пользователь = ВТ_ЗаместителиИВизы.Заместитель)
	 |		ПО ВТ_УстановленныеВизы.Виза = ВТ_ЗаместителиИВизы.Виза
	 |			И ВТ_УстановленныеВизы.ФизическоеЛицоПользователь = ВТ_ЗаместителиИВизы.Пользователь
	 |ГДЕ
	 |	(ВТ_ЗаместителиЗаместителей.Инициатор = &Инициатор
	 |			ИЛИ ВТ_ЗаместителиЗаместителей.Заместитель = &Пользователь)";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("Инициатор", ПараметрыСеанса.бит_БК_ТекущийИнициатор);
	Запрос.УстановитьПараметр("Пользователь", бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"));
	
	Возврат Запрос.Выполнить();
КонецФункции
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-21 (#3997)

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-04-07 (#4117)
&НаКлиенте
Процедура ОбновитьИсториюПереписки(Команда)
	ЗаполнитьИсториюПереписки();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФайлы(Команда)
	ЗаполнитьФайлы();
КонецПроцедуры
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-04-07 (#4117) 

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-08-31 (#4185) 
&НаСервереБезКонтекста
Функция ПолучитьТаблицуНесопоставленнойНоменклатуры(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НоменклатураКонтрагентовБЭД.Владелец КАК Владелец,
	               |	НоменклатураКонтрагентовБЭД.Идентификатор КАК Идентификатор,
	               |	НоменклатураКонтрагентовБЭД.Наименование КАК Наименование,
	               |	НоменклатураКонтрагентовБЭД.НаименованиеХарактеристики КАК НаименованиеХарактеристики,
	               |	НоменклатураКонтрагентовБЭД.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	НоменклатураКонтрагентовБЭД.ЕдиницаИзмеренияКод КАК ЕдиницаИзмеренияКод,
	               |	НоменклатураКонтрагентовБЭД.Артикул КАК Артикул,
	               |	НоменклатураКонтрагентовБЭД.СтавкаНДС КАК СтавкаНДС,
	               |	НоменклатураКонтрагентовБЭД.Штрихкод КАК Штрихкод,
	               |	НоменклатураКонтрагентовБЭД.ИдентификаторНоменклатурыСервиса КАК ИдентификаторНоменклатурыСервиса,
	               |	НоменклатураКонтрагентовБЭД.ИдентификаторХарактеристикиСервиса КАК ИдентификаторХарактеристикиСервиса,
	               |	НоменклатураКонтрагентовБЭД.Номенклатура КАК Номенклатура,
	               |	НоменклатураКонтрагентовБЭД.Характеристика КАК Характеристика,
	               |	НоменклатураКонтрагентовБЭД.Упаковка КАК Упаковка
	               |ИЗ
	               |	РегистрСведений.НоменклатураКонтрагентовБЭД КАК НоменклатураКонтрагентовБЭД
	               |ГДЕ
	               |	НоменклатураКонтрагентовБЭД.Владелец = &Владелец
	               |	И НоменклатураКонтрагентовБЭД.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)";
	
	Запрос.УстановитьПараметр("Владелец", Документ.Контрагент);
	Результат = Запрос.Выполнить(); 
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе	
		
		Выборка = Результат.Выбрать();
		НаборНоменклатурыКонтрагентов = Новый Массив;
	
		Пока Выборка.Следующий() Цикл		
			НоменклатураКонтрагента = ОбменСКонтрагентамиСлужебныйКлиентСервер.НоваяНоменклатураКонтрагента();
			ЗаполнитьЗначенияСвойств(НоменклатураКонтрагента, Выборка);
			НаборНоменклатурыКонтрагентов.Добавить(НоменклатураКонтрагента);		
		КонецЦикла;
	
		Возврат НаборНоменклатурыКонтрагентов;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СопоставитьНоменклатуру(Команда)
	
	ТаблицаНоменклатуры = ПолучитьТаблицуНесопоставленнойНоменклатуры(Документ);
	Если ТаблицаНоменклатуры = Неопределено Тогда
		ПоказатьПредупреждение(,"У данного контрагента вся номенклатура сопоставлена");
	Иначе	
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьСопоставлениеНоменклатуры(ТаблицаНоменклатуры);	
	КонецЕсли;
	
КонецПроцедуры
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-08-31 (#4185) 
#КонецОбласти

СкрываемыеКоманды = Новый Массив;
//СкрываемыеКоманды.Добавить("ФайлыПоказатьПредставление");
