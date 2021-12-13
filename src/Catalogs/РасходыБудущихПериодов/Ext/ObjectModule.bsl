﻿//ОК Ванюков К. +// при копировании строк справочника РБП очищать все значения, кроме наименования и счета // 2013-03-19
Процедура ПриКопировании(ОбъектКопирования)
	
	МассивИсключений	= Новый Массив;
	МассивИсключений.Добавить("Наименование");
	МассивИсключений.Добавить("СчетЗатрат");
	
	// +СБ. Чеплин Денис. 12-10-2016. Автозаполнение доп. полей при копировании (#2689) 
	МассивИсключений.Добавить("ВидРБП");
	МассивИсключений.Добавить("ВидАктива");
	МассивИсключений.Добавить("Объект");
	МассивИсключений.Добавить("Контрагент");
	МассивИсключений.Добавить("ДоговорКонтрагента");
	МассивИсключений.Добавить("ПринадлежностьРасчетов");
	МассивИсключений.Добавить("ОК_Функция");
	МассивИсключений.Добавить("СубконтоЗатрат1");
	МассивИсключений.Добавить("СубконтоЗатрат2");
	МассивИсключений.Добавить("СубконтоЗатрат3");
	МассивИсключений.Добавить("СпособПризнанияРасходов");
	// +СБ. Светличный Михаил. 24-01-2017. Справочник РБП (#2757)
	//МассивИсключений.Добавить("бит_ВидРБП_МСФО");
	//МассивИсключений.Добавить("бит_Субконто1");         
	//МассивИсключений.Добавить("бит_Субконто2");	
	// -СБ. Светличный Михаил 
	// +СБ. Чеплин Денис
	
	Для Каждого Рекв из ЭтотОбъект.Метаданные().Реквизиты Цикл 
		Если МассивИсключений.Найти(Рекв.Имя) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		ЭтотОбъект[Рекв.Имя] = Неопределено;
	КонецЦикла;
	
	Для Сч = 1 По 3 Цикл
		ТипСубк = СчетЗатрат.ВидыСубконто[Сч - 1].ВидСубконто.ТипЗначения;
		
		Если ТипСубк.ПривестиЗначение(ЭтотОбъект["СубконтоЗатрат" + Сч]) <> ЭтотОбъект["СубконтоЗатрат" + Сч] Тогда
			ЭтотОбъект["СубконтоЗатрат" + Сч] = ТипСубк.ПривестиЗначение(ЭтотОбъект["СубконтоЗатрат" + Сч]);
		КонецЕсли;
		
	КонецЦикла;
	
	//СофтЛаб Начало 2018-09-24 3091
	Ок_СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.ПустаяСсылка");
	//СофтЛаб Конец 2018-09-24 3091
	
КонецПроцедуры

//ОК Ванюков К. -

// +СБ. Светличный Михаил. 2017-01-25.  Справочник РБП (#2757)
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("СубконтоЗатрат1");
	ПроверяемыеРеквизиты.Добавить("СубконтоЗатрат2");
	ПроверяемыеРеквизиты.Добавить("СубконтоЗатрат3");
	ПроверяемыеРеквизиты.Добавить("бит_Субконто1");
	ПроверяемыеРеквизиты.Добавить("бит_Субконто2");
	
	ПроверяемыСубконтоЗатрат = Новый Массив;
	ПроверяемыСубконтоЗатрат.Добавить(СубконтоЗатрат1);
	ПроверяемыСубконтоЗатрат.Добавить(СубконтоЗатрат2);
	ПроверяемыСубконтоЗатрат.Добавить(СубконтоЗатрат3);
	
	Для Индекс = 0 по ПроверяемыСубконтоЗатрат.Количество()-1 Цикл
		СубконтоЗатрат = ПроверяемыСубконтоЗатрат.Получить(Индекс);
		Если ТипЗнч(СубконтоЗатрат)=Тип("СправочникСсылка.СтатьиЗатрат")Или ТипЗнч(СубконтоЗатрат)=Тип("СправочникСсылка.ПрочиеДоходыИРасходы") Тогда
			Если НЕ ЗначениеЗаполнено(СубконтоЗатрат) Тогда 
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = "Не указана Статья затрат!";
				Сообщение.Поле = "СубконтоЗатрат"+(Индекс+1);
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Сообщить();
				Отказ = Истина;
				Прервать;
			ИначеЕсли ЗначениеЗаполнено(бит_ВидРБП_МСФО)и бит_ВидРБП_МСФО <> ОпределитьВидРБП(СубконтоЗатрат) Тогда
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = "Вид РБП(МФСО) не соответствует указанной статье затрат!";
				Сообщение.Поле = "бит_ВидРБП_МСФО";
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Сообщить();
				Отказ = Истина;
				Прервать;
			КонецЕсли;
		ИначеЕсли ТипЗнч(СубконтоЗатрат)=Тип("СправочникСсылка.Подразделения") и НЕ ЗначениеЗаполнено(ОК_Функция) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Поле функция не заполнено!";
			Сообщение.Поле = "ОК_Функция";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
			Отказ = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(бит_ВидРБП_МСФО) и ВидАктива <> ОпределитьВидАктива(бит_ВидРБП_МСФО) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Вид актива в балансе не соответствует указанному виду РБП(МФСО)!";
		Сообщение.Поле = "ВидАктива";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если ТипЗнч(бит_Субконто1) = Тип("СправочникСсылка.ОбъектыСтроительства") 
		и бит_Субконто1 <> Объект Тогда 
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Субконто 1 (МСФО) не соответствует объекту!";
		Сообщение.Поле = "бит_Субконто1";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	ИначеЕсли ТипЗнч(бит_Субконто1) = Тип("СправочникСсылка.Контрагенты") 
		и бит_Субконто1 <> Контрагент Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Субконто 1 (МСФО) не соответствует контрагенту!";
		Сообщение.Поле = "бит_Субконто1";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	ИначеЕсли ТипЗнч(бит_Субконто1) = Тип("СправочникСсылка.НематериальныеАктивы") 
		и бит_Субконто1 <> бит_НМА_МСФО Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Субконто 1 (МСФО) не соответствует НМА!";
		Сообщение.Поле = "бит_Субконто1";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	ИначеЕсли ТипЗнч(бит_Субконто2) = Тип("СправочникСсылка.ДоговорыКонтрагентов") 
		и бит_Субконто2 <> ДоговорКонтрагента Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Субконто 2 (МСФО) не соответствует договору!";
		Сообщение.Поле = "бит_Субконто2";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	ИначеЕсли ТипЗнч(бит_Субконто2) = Тип("СправочникСсылка.ОбъектыСтроительства") 
		и бит_Субконто2 <> Объект Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Субконто 2 (МСФО) не соответствует объекту!";
		Сообщение.Поле = "бит_Субконто2";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СубконтоЗатрат1"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СубконтоЗатрат2"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СубконтоЗатрат3"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("бит_Субконто1"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("бит_Субконто2"));
	
	//СофтЛаб Начало 2018-09-24 3091
	Если Не ЭтоГруппа Тогда // Окей Видяйкин В. 2019-08-30 AT-1873340 (Ошибка при создании группы справочника) 
		Если Ок_ПроверятьНДС 
			И НЕ ЗначениеЗаполнено(Ок_СтавкаНДС) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Не указана Ставка НДС!";
			Сообщение.Поле = "Ок_СтавкаНДС";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли; // Окей Видяйкин В. 2019-08-30 AT-1873340 (Ошибка при создании группы справочника)
	//СофтЛаб Конец 2018-09-24 3091
	
КонецПроцедуры

Функция ОпределитьВидРБП(СубконтоЗатрат)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_СоответствияАналитик.ПраваяАналитика_1 КАК ВидРБП_МСФО
	|ИЗ
	|	РегистрСведений.бит_СоответствияАналитик КАК бит_СоответствияАналитик
	|ГДЕ
	|	бит_СоответствияАналитик.ВидСоответствия = ЗНАЧЕНИЕ(Справочник.бит_ВидыСоответствийАналитик.Субконто_ВидРБП_МСФО)
	|	И бит_СоответствияАналитик.ЛеваяАналитика_1 = &Субконто";
	
	Запрос.УстановитьПараметр("Субконто", СубконтоЗатрат);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.ВидРБП_МСФО;
	Иначе 
		Сообщить("Статьи затрат: "+СубконтоЗатрат+" не  сопоставлена с видом РБП!");
		Возврат Справочники.бит_му_ВидыРБП.ПустаяСсылка();
	КонецЕсли;
КонецФункции

Функция ОпределитьВидАктива(бит_ВидРБП_МСФО)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_СоответствияАналитик.ПраваяАналитика_1 КАК ВидАктива
	|ИЗ
	|	РегистрСведений.бит_СоответствияАналитик КАК бит_СоответствияАналитик
	|ГДЕ
	|	бит_СоответствияАналитик.ВидСоответствия = ЗНАЧЕНИЕ(Справочник.бит_ВидыСоответствийАналитик.ВидРБП_МСФО_ВидАктива)
	|	И бит_СоответствияАналитик.ЛеваяАналитика_1 = &ВидРБП_МСФО";
	
	Запрос.УстановитьПараметр("ВидРБП_МСФО", бит_ВидРБП_МСФО);	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		ВидАктиваСопоставленный	= Выборка.ВидАктива;
	Иначе 
		// ++ БоровинскаяОА (СофтЛаб) 18.12.18 Начало (#3130)
		// закоментировала следующую строку
		//Сообщить("Для вида РПБ: " + бит_ВидРБП_МСФО + " не сопоставлен Вид актива ");
		// нужен возврат пустой ссылки, похоже на ошибку..
		//Возврат ВидАктиваСопоставленный = Перечисления.ВидыАктивовДляРБП.ПустаяСсылка();
		Возврат Перечисления.ВидыАктивовДляРБП.ПустаяСсылка();
		// -- БоровинскаяОА (СофтЛаб) 18.12.18 Конец (#3130)
	КонецЕсли;
	
	Возврат ВидАктиваСопоставленный;
	
КонецФункции
// -СБ. Светличный Михаил. 2017-01-25.

// ++ БоровинскаяОА (СофтЛаб) 18.12.18 Начало (#3130)
//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-04-03 (#3715)
//Процедура ЗаполнитьСвязанныеСВидомРБПМСФОДанные(СоздатьСвязанныйСРБП_НМА,СоздатьНМАДляСубконто) Экспорт
Процедура ЗаполнитьСвязанныеСВидомРБПМСФОДанные(СоздатьСвязанныйСРБП_НМА,СоздатьНМАДляСубконто, ЗаполнятьФункцию = Истина) Экспорт
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-04-03 (#3715)
	
	//перенесен и адаптирован код из модуля формы
	
	РБП = бит_ОбщегоНазначения.ЗначенияРеквизитовОбъекта(бит_ВидРБП_МСФО, "ТипСубконто1, ТипСубконто2");
	Если ЗначениеЗаполнено(РБП.ТипСубконто1) Тогда
		
		Если НЕ (ТипЗнч(бит_Субконто1)=Тип("Строка") ИЛИ бит_Субконто1 = Неопределено) Тогда
			бит_Субконто1 = РБП.ТипСубконто1.ТипЗначения.ПривестиЗначение(бит_Субконто1);
		Иначе
			бит_Субконто1 = РБП.ТипСубконто1.ТипЗначения.ПривестиЗначение();
		КонецЕсли;
	Иначе
		бит_Субконто1 = "";
	КонецЕсли;
	Если ЗначениеЗаполнено(РБП.ТипСубконто2) Тогда
		
		Если НЕ (ТипЗнч(бит_Субконто2)=Тип("Строка") ИЛИ бит_Субконто2 = Неопределено) Тогда
			бит_Субконто2 = РБП.ТипСубконто2.ТипЗначения.ПривестиЗначение(бит_Субконто2);
		Иначе
			бит_Субконто2 = РБП.ТипСубконто2.ТипЗначения.ПривестиЗначение();
		КонецЕсли;
	Иначе
		бит_Субконто2 = "";
	КонецЕсли;
		
	Если СоздатьСвязанныйСРБП_НМА Тогда
		//+СБ Пискунова #2799 28.03.2017
		// ++ БоровинскаяОА (СофтЛаб) 22.10.19 Начало (#3508)
		//НовыйЭлементНМА_Ссылка = СозданиеНМА(Объект, Наименование);
		НовыйЭлементНМА_Ссылка = СозданиеНМА(бит_НМА_МСФО, Объект, Наименование);
		// -- БоровинскаяОА (СофтЛаб) 22.10.19 Конец (#3508)
		Если ЗначениеЗаполнено(НовыйЭлементНМА_Ссылка) Тогда 
			// в модуле формы потом в это значение проставлялась пустая ссылка... поэтому пока закомментирую
			//бит_НМА_МСФО  = НовыйЭлементНМА_Ссылка; 
			Если ТипЗнч(бит_Субконто1) = Тип("СправочникСсылка.НематериальныеАктивы")	Тогда
				бит_Субконто1  = НовыйЭлементНМА_Ссылка;
			КонецЕсли;
		КонецЕсли;
		//-СБ Пискунова #2799 28.03.2017
	КонецЕсли;
	
	Если ТипЗнч(бит_Субконто1) = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		Если СоздатьНМАДляСубконто Тогда
			// ++ БоровинскаяОА (СофтЛаб) 22.10.19 Начало (#3508)
			//НовыйЭлементНМА_Ссылка = СозданиеНМА(Объект, Наименование);
			НовыйЭлементНМА_Ссылка = СозданиеНМА(бит_НМА_МСФО, Объект, Наименование);
			// -- БоровинскаяОА (СофтЛаб) 22.10.19 Конец (#3508)
			Если ЗначениеЗаполнено(НовыйЭлементНМА_Ссылка) Тогда 
				бит_НМА_МСФО  = НовыйЭлементНМА_Ссылка;
			КонецЕсли;
		КонецЕсли;
		бит_Субконто1 = бит_НМА_МСФО;
	КонецЕсли;
			
	Если ТипЗнч(бит_Субконто1) = Тип("СправочникСсылка.ОбъектыСтроительства") Тогда 
		бит_Субконто1 = Объект;
	КонецЕсли;
	
	Если ТипЗнч(бит_Субконто2) = Тип("СправочникСсылка.ОбъектыСтроительства") Тогда 
		бит_Субконто2 = Объект;
	КонецЕсли;
	
	// +СБ. Светличный Михаил. 2017-01-25.  Справочник РБП (#2757)
	Если ТипЗнч(бит_Субконто1) = Тип("СправочникСсылка.Контрагенты") Тогда 
		бит_Субконто1 = Контрагент;
	КонецЕсли;
	
	Если ТипЗнч(бит_Субконто2) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда    
		бит_Субконто2 = ДоговорКонтрагента;
	КонецЕсли;
	// -СБ. Светличный Михаил. 2017-01-25.
	
	нВидАктива = ОпределитьВидАктива(бит_ВидРБП_МСФО);
	Если ЗначениеЗаполнено(нВидАктива) Тогда 
		ВидАктива = нВидАктива;
	КонецЕсли;
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-04-03 (#3715)
	Если ЗаполнятьФункцию Тогда
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-04-03 (#3715)
	//**Дремов ОКЕЙ #2799 начало
	нОК_Функция = Справочники.Подразделения.ПустаяСсылка();
	Если ЗначениеЗаполнено(Родитель) 
		и (Родитель.ПринадлежитЭлементу(Справочники.РасходыБудущихПериодов.НайтиПоКоду("Огр-00248"))  //*ФрешМаркет
		или Родитель = Справочники.РасходыБудущихПериодов.НайтиПоКоду("Огр-00248"))
		Тогда
		// ++ БоровинскаяОА (СофтЛаб) 18.12.18 Начало (#3130)
		//нОК_Функция =  Справочники.Подразделения.НайтиПоКоду("000000042");
		Отбор = Новый Структура("Группа,ИмяНастройки, СБ_ПорядковыйНомерЗначения","ФМ_Функция","ФМ_Функция", 0);
		СтруктураНастроек = РегистрыСведений.бит_му_Настройки.Получить(Отбор);
		Если СтруктураНастроек.Количество() > 0 ИЛИ ЗначениеЗаполнено(СтруктураНастроек.Значение) Тогда 
			нОК_Функция =  СтруктураНастроек.Значение;
		КонецЕсли;	
		// -- БоровинскаяОА (СофтЛаб) 18.12.18 Начало (#3130)
	Иначе
		нОК_Функция = бит_ВидРБП_МСФО.ОК_Функция;
	КонецЕсли;
	//**Дремов ОКЕЙ #2799 конец
	
	Если ЗначениеЗаполнено(нОК_Функция) Тогда 
		ОК_Функция	= нОК_Функция;
	КонецЕсли;
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-04-03 (#3715)
	КонецЕсли;
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-04-03 (#3715)
	
КонецПроцедуры
// -- БоровинскаяОА (СофтЛаб) 18.12.18 Конец (#3130)

// Перенесена из модуля формы, было наименование ПриИзменениибит_ВидРБП_МСФО_НаСервере_СозданиеНМА
// ++ БоровинскаяОА (СофтЛаб) 22.10.19 Начало (#3508)
//Функция СозданиеНМА(Объект, Наименование)
Функция СозданиеНМА(РанееСвязанныйСРБПНМА, Объект, Наименование)
// -- БоровинскаяОА (СофтЛаб) 22.10.19 Конец (#3508)
	
	//+СБ Пискунова 28.03.2017 #2799/ Добавила проверку по наименованию на уже существующий эдемент справочника НМА
	
	//НовыйЭлементНМА = Справочники.НематериальныеАктивы.СоздатьЭлемент();
	////НовыйЭлементНМА.УдалитьИжтиси_бит_КодРБП = Элемент.ТекущаяСтрока;
	//НовыйЭлементНМА.бит_ОбъектСтроительства = Объект;
	//НовыйЭлементНМА.бит_УчитываетсяКакНМАВМСФО = ИСТИНА;
	//НовыйЭлементНМА.Наименование = Наименование;
	//НовыйЭлементНМА.Записать();
	//Возврат НовыйЭлементНМА.Ссылка;	
	
	// ++ БоровинскаяОА (СофтЛаб) 22.10.19 Начало (#3508)
	НовыйЭлементНМА = Неопределено;
	
	Если ЗначениеЗаполнено(РанееСвязанныйСРБПНМА) И РанееСвязанныйСРБПНМА.бит_УчитываетсяКакНМАВМСФО Тогда
		Если РанееСвязанныйСРБПНМА.бит_ОбъектСтроительства <> Объект 
			ИЛИ РанееСвязанныйСРБПНМА.Наименование <> Наименование Тогда
			НовыйЭлементНМА = РанееСвязанныйСРБПНМА.ПолучитьОбъект();
		Иначе
			Возврат РанееСвязанныйСРБПНМА;
		КонецЕсли;
	ИначеЕсли НЕ ЭтотОбъект.ЭтоНовый() Тогда
	// -- БоровинскаяОА (СофтЛаб) 22.10.19 Конец (#3508)
		
		Наименование = СокрЛП(Наименование);
		Запрос = Новый Запрос;
		Запрос.Текст = 
		// ++ БоровинскаяОА (СофтЛаб) 22.10.19 Начало (#3508)
		"ВЫБРАТЬ
		|	РасходыБудущихПериодов.бит_НМА_МСФО КАК бит_НМА_МСФО
		|ПОМЕСТИТЬ ВТ_НМАСвязанныеСРБП
		|ИЗ
		|	Справочник.РасходыБудущихПериодов КАК РасходыБудущихПериодов
		|ГДЕ
		|	НЕ РасходыБудущихПериодов.ПометкаУдаления
		|	И РасходыБудущихПериодов.бит_НМА_МСФО <> ЗНАЧЕНИЕ(Справочник.НематериальныеАктивы.ПустаяСсылка)
		|	И РасходыБудущихПериодов.Ссылка <> &ТекущийРБП
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		// -- БоровинскаяОА (СофтЛаб) 22.10.19 Конец (#3508)
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	НематериальныеАктивы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК НематериальныеАктивы
		|ГДЕ
		|	НематериальныеАктивы.Наименование = &Наименование
		|	И НЕ НематериальныеАктивы.ПометкаУдаления
		// ++ БоровинскаяОА (СофтЛаб) 22.10.19 Начало (#3508)
		|	И НематериальныеАктивы.бит_УчитываетсяКакНМАВМСФО
		|	И НЕ НематериальныеАктивы.Ссылка В
		|				(ВЫБРАТЬ
		|					ВТ_НМАСвязанныеСРБП.бит_НМА_МСФО КАК бит_НМА_МСФО
		|				ИЗ
		|					ВТ_НМАСвязанныеСРБП КАК ВТ_НМАСвязанныеСРБП)";
		
		
		Запрос.УстановитьПараметр("ТекущийРБП", ЭтотОбъект.Ссылка);
		// -- БоровинскаяОА (СофтЛаб) 22.10.19 Конец (#3508)
		Запрос.УстановитьПараметр("Наименование", Наименование);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			НовыйЭлементНМА = Справочники.НематериальныеАктивы.СоздатьЭлемент();
			//НовыйЭлементНМА.УдалитьИжтиси_бит_КодРБП = Элемент.ТекущаяСтрока;
			// ++ БоровинскаяОА (СофтЛаб) 22.10.19 Начало (#3508)
			// перенесла код заполнения НМА ниже
			//НовыйЭлементНМА.бит_ОбъектСтроительства = Объект;
			//НовыйЭлементНМА.бит_УчитываетсяКакНМАВМСФО = ИСТИНА;
			//НовыйЭлементНМА.Наименование = Наименование;
			//НовыйЭлементНМА.Записать();
			//Возврат НовыйЭлементНМА.Ссылка;
			// -- БоровинскаяОА (СофтЛаб) 22.10.19 Конец (#3508)
		Иначе   			
			Выборка = РезультатЗапроса.Выбрать(); 			
			Выборка.Следующий();
			// ++ БоровинскаяОА (СофтЛаб) 22.10.19 Начало (#3508)
			//Возврат  Выборка.Ссылка;
			НовыйЭлементНМА = Выборка.Ссылка.ПолучитьОбъект();
			// -- БоровинскаяОА (СофтЛаб) 22.10.19 Конец (#3508)
		КонецЕсли;
		//+СБ Пискунова 28.03.2017 #2799/ Добавила проверку по наименованию на уже существующий эдемент справочника НМА
		
	// ++ БоровинскаяОА (СофтЛаб) 22.10.19 Начало (#3508)
	Иначе
		НовыйЭлементНМА = Справочники.НематериальныеАктивы.СоздатьЭлемент();
	КонецЕсли;
	
	НовыйЭлементНМА.бит_ОбъектСтроительства = Объект;
	НовыйЭлементНМА.бит_УчитываетсяКакНМАВМСФО = ИСТИНА;
	НовыйЭлементНМА.Наименование = Наименование;
	НовыйЭлементНМА.Записать();
	Возврат НовыйЭлементНМА.Ссылка;
	// -- БоровинскаяОА (СофтЛаб) 22.10.19 Конец (#3508)
	
КонецФункции

//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2019-12-29 (#3415)
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Событие")
		И ДанныеЗаполнения.Событие = "СозданиеРБПизОперацииАксапты" Тогда
		
		ЗаполинтьРБПизОперацииАксапты(ДанныеЗаполнения);
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-27 (#4382)
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Событие")
		И ДанныеЗаполнения.Событие = "СозданиеРБПизПоступленияУслуг" Тогда
		
		ЗаполинтьРБПизПоступленияУслуг(ДанныеЗаполнения);
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-27 (#4382)
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполинтьРБПизОперацииАксапты(ДанныеЗаполнения)
	
	Если НЕ (ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
			И ДанныеЗаполнения.Свойство("ОперацияАксапты")
			И ДанныеЗаполнения.Свойство("НомерСтрокиТЧ")) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	бит_ок_ОборотыАксаптыОбороты.Субконто1СКт1 КАК Субконто1СКт1,
		|	бит_ок_ОборотыАксаптыОбороты.Субконто1СКт2 КАК Субконто1СКт2,
		|	бит_ок_ОборотыАксаптыОбороты.Субконто1СДт1 КАК Субконто1СДт1,
		|	бит_ок_ОборотыАксаптыОбороты.Субконто1СДт3 КАК Субконто1СДт3,
		|	бит_ок_ОборотыАксаптыОбороты.Субконто1СДт4 КАК Субконто1СДт4,
		|	бит_ок_ОборотыАксаптыОбороты.СуммаОборот КАК Сумма
		|ИЗ
		|	РегистрНакопления.бит_ок_ОборотыАксапты.Обороты(&НачалоПериода, &КонецПериода, Запись, ) КАК бит_ок_ОборотыАксаптыОбороты
		|ГДЕ
		|	бит_ок_ОборотыАксаптыОбороты.Регистратор = &Регистратор
		|	И бит_ок_ОборотыАксаптыОбороты.НомерСтроки = &НомерСтроки";
		
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоДня(ДанныеЗаполнения.ОперацияАксапты.Дата));
	Запрос.УстановитьПараметр("КонецПериода", 	КонецДня(ДанныеЗаполнения.ОперацияАксапты.Дата));
	Запрос.УстановитьПараметр("Регистратор", 	ДанныеЗаполнения.ОперацияАксапты);
	Запрос.УстановитьПараметр("НомерСтроки", 	ДанныеЗаполнения.НомерСтрокиТЧ);
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-10-26 (#ПроектИнтеграцияАксапта12)
	Если ТипЗнч(ДанныеЗаполнения.ОперацияАксапты) = Тип("ДокументСсылка.бит_ок_ОперацияАксапты12") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "РегистрНакопления.бит_ок_ОборотыАксапты", "РегистрНакопления.бит_ок_ОборотыАксапты12");
	КонецЕсли;
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-10-26 (#ПроектИнтеграцияАксапта12)
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		
		Контрагент 			= Выборка.Субконто1СКт1;
		ДоговорКонтрагента 	= Выборка.Субконто1СКт2;
		Объект 				= Выборка.Субконто1СДт1;
		ОК_Функция 			= Выборка.Субконто1СДт4;
		СубконтоЗатрат1 	= Выборка.Субконто1СДт3;
		СубконтоЗатрат2 	= Выборка.Субконто1СДт1;
		СубконтоЗатрат3 	= Выборка.Субконто1СДт4;
		Сумма 				= Выборка.Сумма;
		
	КонецЕсли;
	
	Ок_СозданНаОснованииОперацииАксапты = Истина;
	
	Ок_СтавкаНДС			= ДанныеЗаполнения.СтавкаНДС;
	Родитель 				= ОК_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("РБП","ГруппаВерхнегоУровняРБП");
	ПринадлежностьРасчетов 	= ОК_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("РБП","ПринадлежностьРасчетовРБП");
	СчетЗатрат 				= ОК_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("РБП","СчетЗатратРБП");
	ВидРБП 					= Перечисления.ВидыРБП.Прочие;
	ВидАктива 				= Перечисления.ВидыАктивовДляРБП.ПрочиеОборотныеАктивы;
	Ок_ПроверятьНДС 		= Истина;
	СпособПризнанияРасходов = Перечисления.СпособыПризнанияРасходов.ПоМесяцам;
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-04-22 (#3715)
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-27 (#4382) вынес в отдельную процедуру чтобы вызывать из других мест
	//пСтатьиЗатрат = Неопределено;
	//Если ЗначениеЗаполнено(СубконтоЗатрат1)
	//	И (ТипЗнч(СубконтоЗатрат1) = Тип("СправочникСсылка.СтатьиЗатрат")
	//		ИЛИ ТипЗнч(СубконтоЗатрат1) = Тип("СправочникСсылка.ПрочиеДоходыИРасходы"))	Тогда 
	//	
	//	пСтатьиЗатрат = СубконтоЗатрат1;
	//	
	//ИначеЕсли ЗначениеЗаполнено(СубконтоЗатрат2)
	//	И (ТипЗнч(СубконтоЗатрат2) = Тип("СправочникСсылка.СтатьиЗатрат")
	//		ИЛИ ТипЗнч(СубконтоЗатрат2) = Тип("СправочникСсылка.ПрочиеДоходыИРасходы")) Тогда 
	//		
	//	пСтатьиЗатрат = СубконтоЗатрат2;
	//	
	//ИначеЕсли ЗначениеЗаполнено(СубконтоЗатрат3)
	//	И (ТипЗнч(СубконтоЗатрат3) = Тип("СправочникСсылка.СтатьиЗатрат")
	//		ИЛИ ТипЗнч(СубконтоЗатрат3) = Тип("СправочникСсылка.ПрочиеДоходыИРасходы")) Тогда 
	//		
	//	пСтатьиЗатрат = СубконтоЗатрат3;
	//	
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(пСтатьиЗатрат) Тогда
	//	бит_ВидРБП_МСФО = ОК_СубконтоПриИзмененииНаСервере(пСтатьиЗатрат);
	//	Если ЗначениеЗаполнено(бит_ВидРБП_МСФО) Тогда 
	//		ПриИзменениибит_ВидРБП_МСФО();
	//	КонецЕсли;
	//КонецЕсли;
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-04-22 (#3715)
	ПерезаполнитьСвязанныеРеквизитыПоСтатьеЗатрат(ДанныеЗаполнения);
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-27 (#4382)
	
	Комментарий				= "<Документ_ОА>Номер операции аксапта №" + ДанныеЗаполнения.ОперацияАксапты.Номер + " от " + Формат(ДанныеЗаполнения.ОперацияАксапты.Дата, "ДФ=dd.MM.yyyy") + "</ Документ_ОА >";
КонецПроцедуры
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2019-12-29 (#3415)

//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-04-22 (#3715)
Функция ОК_СубконтоПриИзмененииНаСервере(СубконтоЗатрат)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	бит_СоответствияАналитик.ПраваяАналитика_1 КАК ВидРБП_МСФО
	               |ИЗ
	               |	РегистрСведений.бит_СоответствияАналитик КАК бит_СоответствияАналитик
	               |ГДЕ
	               |	бит_СоответствияАналитик.ВидСоответствия = ЗНАЧЕНИЕ(Справочник.бит_ВидыСоответствийАналитик.Субконто_ВидРБП_МСФО)
	               |	И бит_СоответствияАналитик.ЛеваяАналитика_1 = &Субконто";
	
	Запрос.УстановитьПараметр("Субконто", СубконтоЗатрат);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.ВидРБП_МСФО;
	Иначе 
		Возврат Справочники.бит_му_ВидыРБП.ПустаяСсылка();
	КонецЕсли;
КонецФункции

Процедура ПриИзменениибит_ВидРБП_МСФО()
	
	РБП = бит_ОбщегоНазначения.ЗначенияРеквизитовОбъекта(бит_ВидРБП_МСФО, "ТипСубконто1, ТипСубконто2");
	
	СоздатьСвязанныйСРБП_НМА = Ложь;
	СоздатьНМАДляСубконто = Ложь;
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-26 (#3816)
	//Если ИнтеграцияЕГАИСВызовСервера.ЗначениеРеквизитаОбъекта(РБП.ТипСубконто1, "ТипЗначения") <> Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы")
	//	И
	//	ИнтеграцияЕГАИСВызовСервера.ЗначениеРеквизитаОбъекта(РБП.ТипСубконто2, "ТипЗначения") <> Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы")
	//	Тогда
	Если ОК_ОбщегоНазначения.ПолучитьЗначенияРеквизитов(РБП.ТипСубконто1, "ТипЗначения") <> Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы")
		И ОК_ОбщегоНазначения.ПолучитьЗначенияРеквизитов(РБП.ТипСубконто2, "ТипЗначения") <> Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы")
		Тогда
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-26 (#3816)
		бит_НМА_МСФО = ПредопределенноеЗначение("Справочник.НематериальныеАктивы.ПустаяСсылка");
	КонецЕсли;
	 
	ЗаполнитьСвязанныеСВидомРБПМСФОДанные(СоздатьСвязанныйСРБП_НМА,СоздатьНМАДляСубконто, Ложь);	
	
КонецПроцедуры
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-04-22 (#3715)

// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-19 (#4390)
Функция ПолучитьПроектИзФВБДляРБП(СтатьяРегл, ОперацияАксапты)	
	ПроектИзФВБ = Неопределено;
	
	ЗапросПоФВБ = Новый Запрос;
	ЗапросПоФВБ.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	бит_СтатьиОборотов_СтатьиРегл.СтатьяОборотов.ВидСтатьи КАК ВидСтатьиОборотов,
		|	МАКСИМУМ(бит_СтатьиОборотов_СтатьиРегл.ок_ОсновноеСоответствие) КАК ок_ОсновноеСоответствие
		|ПОМЕСТИТЬ ТабСтатьяОборотов
		|ИЗ
		|	РегистрСведений.бит_СтатьиОборотов_СтатьиРегл КАК бит_СтатьиОборотов_СтатьиРегл
		|ГДЕ
		|	бит_СтатьиОборотов_СтатьиРегл.СтатьяРегл = &СтатьяРегл
		|
		|СГРУППИРОВАТЬ ПО
		|	бит_СтатьиОборотов_СтатьиРегл.СтатьяОборотов.ВидСтатьи
		|
		|УПОРЯДОЧИТЬ ПО
		|	ок_ОсновноеСоответствие УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	бит_ФормаВводаБюджетаБДДС.Проект КАК Проект
		|ИЗ
		|	РегистрСведений.бит_ДополнительныеДанныеПоОперациямАксапты КАК бит_ДополнительныеДанныеПоОперациямАксапты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.бит_ФормаВводаБюджета.БДДС КАК бит_ФормаВводаБюджетаБДДС
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТабСтатьяОборотов КАК ТабСтатьяОборотов
		|			ПО (ТабСтатьяОборотов.ВидСтатьиОборотов = бит_ФормаВводаБюджетаБДДС.СтатьяОборотов.ВидСтатьи)
		|		ПО бит_ДополнительныеДанныеПоОперациямАксапты.НомерЗаявки = бит_ФормаВводаБюджетаБДДС.Ссылка
		|ГДЕ
		|	бит_ДополнительныеДанныеПоОперациямАксапты.Документ = &ОперацияАксапты
		|
		|УПОРЯДОЧИТЬ ПО
		|	бит_ФормаВводаБюджетаБДДС.НомерСтроки";
	ЗапросПоФВБ.УстановитьПараметр("ОперацияАксапты", ОперацияАксапты);
	ЗапросПоФВБ.УстановитьПараметр("СтатьяРегл", СтатьяРегл);
	
	Результат = ЗапросПоФВБ.Выполнить();
	Если Не Результат.Пустой() Тогда 
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ПроектИзФВБ = Выборка.Проект;
	КонецЕсли;
	
	Возврат ПроектИзФВБ;
КонецФункции
// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-19 (#4390)

// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-27 (#4382)
Процедура ЗаполинтьРБПизПоступленияУслуг(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	ПерезаполнитьСвязанныеРеквизитыПоСтатьеЗатрат(ДанныеЗаполнения);
	
	ВидАктива = Перечисления.ВидыАктивовДляРБП.ПрочиеОборотныеАктивы;
	
КонецПроцедуры

Процедура ПерезаполнитьСвязанныеРеквизитыПоСтатьеЗатрат(ДанныеЗаполнения) Экспорт
	пСтатьиЗатрат = Неопределено;
	Если ЗначениеЗаполнено(СубконтоЗатрат1)
		И (ТипЗнч(СубконтоЗатрат1) = Тип("СправочникСсылка.СтатьиЗатрат")
		ИЛИ ТипЗнч(СубконтоЗатрат1) = Тип("СправочникСсылка.ПрочиеДоходыИРасходы"))	Тогда 
		
		пСтатьиЗатрат = СубконтоЗатрат1;
		
	ИначеЕсли ЗначениеЗаполнено(СубконтоЗатрат2)
		И (ТипЗнч(СубконтоЗатрат2) = Тип("СправочникСсылка.СтатьиЗатрат")
		ИЛИ ТипЗнч(СубконтоЗатрат2) = Тип("СправочникСсылка.ПрочиеДоходыИРасходы")) Тогда 
		
		пСтатьиЗатрат = СубконтоЗатрат2;
		
	ИначеЕсли ЗначениеЗаполнено(СубконтоЗатрат3)
		И (ТипЗнч(СубконтоЗатрат3) = Тип("СправочникСсылка.СтатьиЗатрат")
		ИЛИ ТипЗнч(СубконтоЗатрат3) = Тип("СправочникСсылка.ПрочиеДоходыИРасходы")) Тогда 
		
		пСтатьиЗатрат = СубконтоЗатрат3;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(пСтатьиЗатрат) Тогда
		бит_ВидРБП_МСФО = ОК_СубконтоПриИзмененииНаСервере(пСтатьиЗатрат);
		Если ЗначениеЗаполнено(бит_ВидРБП_МСФО) Тогда 
			ПриИзменениибит_ВидРБП_МСФО();
		КонецЕсли;
		
		// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-19 (#4390)
		Если ДанныеЗаполнения.Событие = "СозданиеРБПизОперацииАксапты"
			И ТипЗнч(пСтатьиЗатрат) = Тип("СправочникСсылка.СтатьиЗатрат") Тогда 
			
			ок_Проект = ПолучитьПроектИзФВБДляРБП(пСтатьиЗатрат, ДанныеЗаполнения.ОперацияАксапты);
			
		КонецЕсли;
		// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-19 (#4390)
		
	КонецЕсли;
		
КонецПроцедуры
// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-27 (#4382)
